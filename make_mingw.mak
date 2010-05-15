
all: autoload/syslib.dll

autoload/syslib.dll: autoload/syslib_win.cpp
	g++ -Wall -W -shared autoload/syslib_win.cpp -o autoload/syslib.dll -L/mingw/lib -lole32 -luuid

