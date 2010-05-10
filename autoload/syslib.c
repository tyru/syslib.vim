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





int remove_directory(const char *pathname);




int
remove_directory(const char *pathname)
{
    return rmdir(pathname);
}
