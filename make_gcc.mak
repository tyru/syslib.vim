CFLAGS=-W -Wall -Wno-unused -std=c89 -pedantic -shared

TARGET=autoload/syslib.so
SRC=src/syslib.c
CFLAGS+=-fPIC
# LDFLAGS+=-lutil

all: $(TARGET)

$(TARGET): $(SRC)
	gcc $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

