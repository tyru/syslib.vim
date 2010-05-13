
all: autoload/syslib.dll

autoload/syslib.dll: autoload/syslib_win.c
	gcc -Wall -shared autoload/syslib_win.c -o autoload/syslib.dll

