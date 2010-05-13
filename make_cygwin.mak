CFLAGS=-W -Wall -Wno-unused -std=gnu99 -pedantic -shared

TARGET=autoload/syslib.dll
SRC=autoload/syslib.c
# LDFLAGS+=-lutil

all: $(TARGET)

$(TARGET): $(SRC)
	gcc $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

