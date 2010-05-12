/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * test.c
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-13.
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>


#define STREQ(s1, s2)   (*(s1) == *(s2) && strcmp((s1), (s2)) == 0)



#include "syslib.c"


static char*
concat(char *dest, int arg_num, ...)
{
    char *orig = dest;
    va_list list;
    int i;

    va_start(list, arg_num);
    for (i = 0; i < arg_num; i++) {
        char *p = va_arg(list, char*);
        strcpy(dest, p);
        dest += strlen(p);
    }
    va_end(list);

    return orig;
}

static char*
get_vimrc_path(void)
{
    static char buf[50];

    char *home = getenv("HOME");
    if (!home) abort();
    return concat(buf, 2, home, "/.vimrc");
}

int
main(int argc, char *argv[])
{
    int ret;
    char *vimrc = get_vimrc_path();
    char args[50];

    memset(args, 0, sizeof args);
    concat(args, 3, "foo_symlink" "\xFF", vimrc, "\xFF" "\xFF");

    unlink("foo_symlink");
    errno = 0;
    ret = create_symlink(args);
    perror("create_symlink()");
    printf("ret = %d, strerror() = %s\n", ret, strerror(ret));

    memset(args, 0, sizeof args);
    concat(args, 3, "foo_hardlink" "\xFF", vimrc, "\xFF" "\xFF");

    // FIXME Can't create hardlink with create_hardlink().
    unlink("foo_hardlink");
    errno = 0;
    ret = create_hardlink(args);
    // ret = create_hardlink_args("foo_hardlink", vimrc);
    // ret = link(vimrc, "foo_hardlink");
    perror("create_hardlink()");
    printf("ret = %d, strerror() = %s\n", ret, strerror(ret));

    return EXIT_SUCCESS;
}
