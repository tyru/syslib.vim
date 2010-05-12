/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * syslib.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-13.
 *
 */


#if defined __linux__ || defined __CYGWIN__ || defined __APPLE__
#   include <unistd.h>
#   include <errno.h>
#else
#   error Your platform is not supported!!
#endif

#include <string.h>
#include <stdlib.h>



/* Debug */

// #define NDEBUG 1

#include <assert.h>

#ifdef NDEBUG
#   define syslib_log(str)
#   define syslib_logf()
#else
#   define syslib_log(str)  puts(str)
#   define syslib_logf printf
#endif





/* API */
int remove_directory(const char *pathname);
int create_symlink(char *args);
int create_hardlink(char *args);



/* NodeArg types */
typedef struct NodeArg_tag {
    struct NodeArg_tag *next;
    char                 *buf;
    size_t                buf_size;
} NodeArg;


/* Global variables */
static NodeArg *the_args = NULL;    // Top argument.
static int last_errno = 0;



static NodeArg*
create_arg(const char *buf)
{
    NodeArg *node = malloc(sizeof(NodeArg));
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
        arg->buf = realloc(arg->buf, buf_size);
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



    return the_args;
}

static char*
serialize_args(Arg* arg)
{
}




int
remove_directory(const char *pathname)
{
    return rmdir(pathname);
}

int
create_symlink(char *args)
{
    Arg *real_args = deserialize_args(args);
    assert(cur_args_num == 2);
    return symlink(real_args[0].buf, real_args[1].buf);
}

int
create_hardlink(char *args)
{
    Arg *real_args = deserialize_args(args);
    assert(cur_args_num == 2);
    return link(real_args[0].buf, real_args[1].buf);
}
