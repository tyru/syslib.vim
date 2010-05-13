/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * syslib_win.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-14.
 *
 */

#include "common.c"
#include <windows.h>



/* syslib functions */
int
syslib_get_current_errno(void)
{
    return GetLastError();
}

int
syslib_get_last_errno(void)
{
    return GetLastError();
}

int
syslib_remove_directory(const char *pathname)
{
    return RemoveDirectory(pathname);
}

int
syslib_create_symlink(const char *args)
{
    NodeArg *real_args = deserialize_args(args);
    return syslib_create_symlink_args(real_args->buf, real_args->next->buf);
}
static int
syslib_create_symlink_args(const char *path, const char *symlink_path)
{
    return 0;
    // int ret = symlink(path, symlink_path);
    // if (ret == -1) {
    //     last_errno = ret;
    // }
    // return ret;
}

int
syslib_create_hardlink(const char *args)
{
    NodeArg *real_args = deserialize_args(args);
    return syslib_create_hardlink_args(real_args->buf, real_args->next->buf);
}
static int
syslib_create_hardlink_args(const char *path, const char *hardlink_path)
{
    return 0;
    // int ret = link(path, hardlink_path);
    // if (ret == -1) {
    //     last_errno = ret;
    // }
    // return ret;
}
