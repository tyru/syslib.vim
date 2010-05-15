
SRC=src/syslib_win.cpp
all: autoload/syslib.dll

autoload/syslib.dll: $(SRC)
	cl /wd4996 /LD /Feautoload/syslib.dll $(SRC)

