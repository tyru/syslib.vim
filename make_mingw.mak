CFLAGS=-W -Wall -Wno-unused -std=c89 -pedantic -shared

all: autoload/syslib.dll

autoload/syslib.dll: autoload/syslib_win.cpp
	g++ $(CFLAGS) autoload/syslib_win.cpp -o autoload/syslib.dll -L/mingw/lib -lole32 -luuid

