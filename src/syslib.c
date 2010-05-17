/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * syslib.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-18.
 *
 */

#include "common.c"



#if defined __linux__ || defined __CYGWIN__ || defined __APPLE__
#   include <unistd.h>
#   include <errno.h>
#else
#   error Your platform is not supported!!
#endif



/* syslib functions */
int
syslib_get_current_errno(void)
{
    return errno;
}

int
syslib_get_last_errno(void)
{
    return last_errno;
}

int
syslib_remove_directory(const char *pathname)
{
    int ret = rmdir(pathname);
    if (ret == -1) {
        last_errno = errno;
    }
    return ret != -1;
}

int
syslib_create_symlink(const char *args)
{
    NodeArg *real_args = deserialize_args(args, 2);
    if (real_args != NULL) {
        return syslib_create_symlink_args(args_ref(real_args, 0)->buf, args_ref(real_args, 1)->buf);
    }
    else {
        /* TODO:
         * Get last error not system's last error.
         * e.g.: invalid argument
         */
        return 0;
    }
}
static int
syslib_create_symlink_args(const char *path, const char *symlink_path)
{
    int ret = symlink(path, symlink_path);
    if (ret == -1) {
        last_errno = ret;
    }
    return ret != -1;
}

int
syslib_create_hardlink(const char *args)
{
    NodeArg *real_args = deserialize_args(args, 2);
    if (real_args != NULL) {
        return syslib_create_hardlink_args(args_ref(real_args, 0)->buf, args_ref(real_args, 1)->buf);
    }
    else {
        /* TODO:
         * Get last error not system's last error.
         * e.g.: invalid argument
         */
        return 0;
    }
}
static int
syslib_create_hardlink_args(const char *path, const char *hardlink_path)
{
    int ret = link(path, hardlink_path);
    if (ret == -1) {
        last_errno = ret;
    }
    return ret != -1;
}
