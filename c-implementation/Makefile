CC = gcc
CFLAGS = -Wall -Wextra -std=c11
SRC_DIR = src
INC_DIR = include
INPUT_DIR = input
OUTPUT_DIR = output
TARGET = aes
SRCS = $(SRC_DIR)/main.c $(SRC_DIR)/aes_encryption.c $(SRC_DIR)/aes_decryption.c $(SRC_DIR)/aes_core.c $(SRC_DIR)/io.c
HDRS = $(INC_DIR)/aes.h $(INC_DIR)/io.h

.PHONY: all run clean

all: $(TARGET)

run: $(TARGET)
	@./$(TARGET) $(INPUT_DIR)/data.txt $(INPUT_DIR)/key.txt $(OUTPUT_DIR)/output.txt

$(TARGET): $(SRCS) $(HDRS)
	@$(CC) $(CFLAGS) -I$(INC_DIR) -o $@ $(SRCS)

clean:
	@rm -f $(TARGET) $(OUTPUT_DIR)/output.txt
