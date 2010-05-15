CFLAGS=-W -Wall -Wno-unused -std=c89 -pedantic -shared

SRC=src/syslib_win.cpp
all: autoload/syslib.dll

autoload/syslib.dll: $(SRC)
	g++ $(CFLAGS) $(SRC) -o autoload/syslib.dll -L/mingw/lib -lole32 -luuid

