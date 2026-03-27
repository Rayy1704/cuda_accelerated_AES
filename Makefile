CC = gcc
CFLAGS = -Wall -Wextra -std=c11

TARGET = aes
SRCS = main.c aes.c io.c
HDRS = aes.h io.h

.PHONY: all run clean

all: $(TARGET)

run: $(TARGET)
	@./$(TARGET) test.txt

$(TARGET): $(SRCS) $(HDRS)
	@$(CC) $(CFLAGS) -o $@ $(SRCS)

clean:
	@rm -f $(TARGET) output.txt
