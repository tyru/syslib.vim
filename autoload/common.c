/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * common.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-15.
 *
 */


#include <string.h>
#include <stdlib.h>



// TOOD If compiler has `inline`, #define INLINE inline
#ifndef INLINE
#   define INLINE
#endif


/* Debug */

#define NDEBUG 1

#include <assert.h>

#ifdef NDEBUG
#   define syslib_log(str)
#   define syslib_logf(fmt, ...)
#   define syslib_flogf(fmt, ...)
#else
#   include <stdio.h>
#   include <stdarg.h>
#   ifndef SYSLIB_LOG_FILE
#       define SYSLIB_LOG_FILE "/tmp/syslib-debug.log"
#   endif
#   define syslib_log(str)  puts(str)
#   define syslib_logf(fmt, ...) printf(fmt, __VA_ARGS__)
static int
syslib_flogf(const char *fmt, ...)
{
    FILE *f = fopen(SYSLIB_LOG_FILE, "a+");
    if (f == NULL) abort();

    va_list vargs;
    va_start(vargs, fmt);
    int ret = vfprintf(f, fmt, vargs);

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

#undef SYSLIB_DECL_BEGIN
#undef SYSLIB_DECL_END



/* NodeArg types */
typedef struct NodeArg_tag {
    struct NodeArg_tag *next;
    char               *buf;
    size_t              buf_size;
} NodeArg;


/* Global variables */
static NodeArg *the_args = NULL;    // Top argument.
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

// TODO
// static NodeArg*
// serialize_args(NodeArg *args)
// {
// }

static NodeArg*
deserialize_args(const char *args)
{
    int debug_arg_count = 1;
    NodeArg *prev_node_ptr = the_args;
    char cur_arg[strlen(args)];    // c99
    size_t cur_arg_pos = 0;
    size_t pos = 0;
    size_t len = strlen(args);

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
            pos++;
            break;
        default:
            cur_arg[cur_arg_pos++] = args[pos];
            pos++;
            break;
        }
    }
    abort();    /* End of bytes */
}
