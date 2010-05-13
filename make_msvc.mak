
all: autoload/syslib.dll

autoload/syslib.dll: autoload/syslib_win.c
	cl /wd4996 /LD /Feautoload/syslib.dll autoload/proc_w32.c

