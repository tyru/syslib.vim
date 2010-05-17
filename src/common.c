/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * common.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-18.
 *
 */


#include <string.h>
#include <stdlib.h>

#if defined(__GNUC__)
#   define alloca __builtin_alloca
#elif defined(_WIN32) || defined(__WIN32__)
#   include <malloc.h>
#   ifdef alloca
#       undef alloca
#   endif
#   define alloca _malloca
#else
#   include <alloca.h>
#endif



/* TOOD If compiler has `inline`, #define INLINE inline */
#ifndef INLINE
#   define INLINE
#endif



/* Utilities */
#ifdef __CYGWIN__ /* cygwin has no strdup(). */
#   define strdup(s) (char*)malloc(strlen(s))
#endif



/* Debug */

#define NDEBUG 1

#include <assert.h>

#ifdef NDEBUG
#   define syslib_log(str)
INLINE static void
syslib_logf(const char *fmt, ...)
{
}
INLINE static void
syslib_flogf(const char *fmt, ...)
{
}
#else
#   include <stdio.h>
#   include <stdarg.h>
#   ifndef SYSLIB_LOG_FILE
        /* TODO Support logging in win32 environment */
#       define SYSLIB_LOG_FILE "/tmp/syslib-debug.log"
#   endif
#   define syslib_log(str)  puts(str)
INLINE static int
syslib_logf(const char *fmt, ...)
{
    va_list vargs;
    int ret;

    va_start(vargs, fmt);
    ret = vprintf(fmt, vargs);
    va_end(vargs);
    return ret;
}
INLINE static int
syslib_flogf(const char *fmt, ...)
{
    va_list vargs;
    FILE *f;
    int ret;

    f = fopen(SYSLIB_LOG_FILE, "a+");
    if (f == NULL) abort();

    va_start(vargs, fmt);
    ret = vfprintf(f, fmt, vargs);

    fclose(f);

    return ret;
}
#endif





/* API */

#ifdef __cplusplus
extern "C" {
#endif

int syslib_get_current_errno(void);
int syslib_get_last_errno(void);

int syslib_remove_directory(const char *pathname);

int syslib_create_symlink(const char *args);
static int syslib_create_symlink_args(const char *path, const char *symlink_path);

int syslib_create_hardlink(const char *args);
static int syslib_create_hardlink_args(const char *path, const char *hardlink_path);

#ifdef __cplusplus
}
#endif



/* NodeArg types */
typedef struct NodeArg_tag {
    struct NodeArg_tag *next;
    char               *buf;
    size_t              buf_size;
} NodeArg;


/* Global variables */
static NodeArg *the_args = NULL;    /* Top argument */
static int last_errno = 0;



static NodeArg*
create_arg(const char *buf)
{
    NodeArg *node = (NodeArg*)malloc(sizeof(NodeArg));
    if (node == NULL) {
        abort();
    }

    node->next = NULL;
    node->buf = strdup(buf);
    if (node->buf == NULL) {
        abort();
    }
    node->buf_size = strlen(buf) + 1;

    return node;
}

static void
set_buf_to_arg(NodeArg *arg, char *buf)
{
    size_t buf_size = strlen(buf) + 1;
    assert(arg->buf != NULL);

    if (arg->buf_size < buf_size) {
        arg->buf = (char*)realloc(arg->buf, buf_size);
        if (arg->buf == NULL) {
            abort();
        }
        arg->buf_size = buf_size;
    }
    strcpy(arg->buf, buf);
}



/* NodeArg functions */

/*
 * TODO
 *
 * static NodeArg*
 * serialize_args(NodeArg *args)
 * {
 * }
 *
 */

static NodeArg*
deserialize_args(const char *args)
{
    int debug_arg_count = 1;
    NodeArg *prev_node_ptr = the_args;
    char *cur_arg;
    size_t cur_type;
    size_t cur_arg_pos = 0;
    size_t pos = 1;
    size_t len = strlen(args);

    if (args[0] == '\0') {
        return NULL;
    }
    cur_type = args[0];

    cur_arg = (char*)alloca(strlen(args) + 1);

    while (pos < len) {
        switch (args[pos]) {
        case '\xFE':
            switch (args[pos + 1]) {
            case '\0': /* No more bytes */
                abort();
                break;
            case '\xFE':
                cur_arg[cur_arg_pos++] = '\xFE';
                pos += 2;
                break;
            case '\xFF':
                cur_arg[cur_arg_pos++] = '\xFF';
                pos += 2;
                break;
            default: /* Escaped but not special character */
                abort();
                break;
            }
            break;
        case '\xFF':
            cur_arg[cur_arg_pos] = '\0';

            /* NOTE: Currently can't manipulate `cur_arg` as only string. */

            if (the_args == NULL) {
                assert(prev_node_ptr == NULL);
                the_args = prev_node_ptr = create_arg(cur_arg);
            }
            else if (prev_node_ptr->next == NULL) {
                prev_node_ptr->next = create_arg(cur_arg);
                prev_node_ptr = prev_node_ptr->next;
            }
            else {
                set_buf_to_arg(prev_node_ptr->next, cur_arg);
                prev_node_ptr = prev_node_ptr->next;
            }

            syslib_logf("argument %d: %s\n", debug_arg_count, cur_arg);
            debug_arg_count++;

            if (args[pos + 1] == '\xFF') {
                return the_args;
            }

            cur_arg_pos = 0;
            cur_type = args[pos + 1];
            pos += 2;
            break;
        default:
            cur_arg[cur_arg_pos++] = args[pos];
            pos++;
            break;
        }
    }

    /* NEVERREACHED */
    abort();    /* End of bytes */
    return NULL; /* Shut up compiler's warning */
}

INLINE static NodeArg*
args_ref(NodeArg *args, size_t index)
{
    size_t i;
    for (i = 0; i < index; i++) {
        args = args->next;
    }
    return args;
}

INLINE static size_t
args_len(NodeArg *args)
{
    size_t i;
    for (i = 0; args != NULL; i++) {
        args = args->next;
    }
    return i;
}
