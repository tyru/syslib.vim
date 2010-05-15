
all: autoload/syslib.dll

autoload/syslib.dll: autoload/syslib_win.cpp
	cl /wd4996 /LD /Feautoload/syslib.dll autoload/syslib_win.cpp

