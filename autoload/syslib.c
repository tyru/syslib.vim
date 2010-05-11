/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * syslib.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-11.
 *
 */


#if defined __linux__ || defined __CYGWIN__ || defined __APPLE__
#   include <unistd.h>
#else
#   error Your platform is not supported!!
#endif

#if NDEBUG
#   include <assert.h>
#else
#   define assert()
#endif





/* API */
int remove_directory(const char *pathname);
int create_symlink(char *args);
int create_hardlink(char *args);



/* Argument types */
typedef struct {
    char *buf;
    size_t buf_size;
} Arg;



/* Global variables */
size_t cur_args_num = 0;
Arg *the_args = NULL;



static void
allocate_args(size_t args_num)
{
    if (the_args == NULL) {
        the_args = calloc(sizeof(Arg), args_num);
        if (the_args == NULL) {
            abort();
        }
    }
    else if (cur_args_num < args_num) {
        realloc(the_args, sizeof(Arg) * args_num);
        if (the_args == NULL) {
            abort();
        }
        memset(the_args + sizeof(Arg), 0, args_num - cur_args_num);
    } else {
        // Shrink current `the_args`?
    }
    cur_args_num = args_num;
}



static void
allocate_arg_obj(Arg *arg, size_t buf_size)
{
    if (arg->buf == NULL) {
        arg->buf = malloc(buf_size);
        if (arg->buf == NULL) {
            abort();
        }
    }
    else {
        realloc(arg->buf, buf_size);
        if (arg->buf == NULL) {
            abort();
        }
    }
    arg->buf_size = buf_size;
}



/* Argument functions */
static Arg*
deserialize_args(char *args)
{
    // TODO Count arguments' length.
    size_t args_len;

    // Set up `the_args`.
    allocate_args(args_num);

    // TODO Assign to `the_args`.
    // Call `allocate_arg_obj()`.

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
