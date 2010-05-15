CFLAGS=-W -Wall -Wno-unused -std=c89 -pedantic -shared

TARGET=autoload/syslib.dll
SRC=autoload/syslib.c
# LDFLAGS+=-lutil

all: $(TARGET)

$(TARGET): $(SRC)
	gcc $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

