# Makefile for C99/SDL3 Ball Game

CC = gcc
CFLAGS = -std=c99 -Wall -Wextra -O2
LDFLAGS = -lSDL3 -lm

# Target executable name
TARGET = ball_game

# Source files
SOURCES = main.c

# Object files
OBJECTS = $(SOURCES:.c=.o)

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

# Compile source files to object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
	rm -f $(OBJECTS) $(TARGET)

# Install SDL3 dependencies (Ubuntu/Debian)
install-deps:
	sudo apt update
	sudo apt install libsdl3-dev

# Run the game
run: $(TARGET)
	./$(TARGET)

# Debug build
debug: CFLAGS += -g -DDEBUG
debug: $(TARGET)

.PHONY: all clean install-deps run debug