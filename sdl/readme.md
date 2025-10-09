# Arcade Ball - C99/SDL3 Version

A C99 port of the Love2D bouncing ball physics game using SDL3.

## Features

- **Realistic Physics**: Gravity, bouncing, friction, and rotation
- **Interactive Controls**: Mouse drag to modify ball velocity
- **Visual Feedback**: Ball rotation indicator and boundary walls
- **Cross-platform**: Works on Linux, Windows, and macOS

## Building and Running

### Prerequisites

You need SDL3 development libraries installed:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install libsdl3-dev

# Or use the Makefile helper:
make install-deps
```

### Compilation

```bash
# Build the game
make

# Or build with debug symbols
make debug

# Run the game
make run

# Clean build files
make clean
```

### Manual Compilation

If you prefer to compile manually:

```bash
gcc -std=c99 -Wall -Wextra -O2 ball_game.c -o ball_game -lSDL3 -lm
./ball_game
```

## Controls

- **Mouse**: Click and drag to add velocity to the ball
- **Escape**: Quit the game

## Code Structure

The C version maintains the same physics logic as the original Love2D version:

### Key Components

1. **GameState Structure**: Holds all game state including ball position, velocity, and rotation
2. **Physics Update**: Gravity, collision detection, friction, and rotation calculations
3. **Rendering**: SDL3-based drawing of boundaries and ball with rotation indicator
4. **Input Handling**: Mouse and keyboard event processing

### Physics Implementation

- **Gravity**: Constant downward acceleration
- **Bouncing**: Energy loss on collision (60% retention)
- **Friction**: Velocity reduction when touching walls/floor (99% per frame)
- **Rotation**: Based on surface contact and velocity

### Differences from Love2D Version

1. **Graphics**: Uses procedural circle drawing instead of image texture
2. **Rotation Visualization**: Yellow line indicates ball rotation
3. **Color Coding**: Red ball, white boundaries, yellow rotation indicator
4. **Fixed Ball Size**: 64 pixels (scaled to 16 pixels visual size)

## Extending the Code

### Adding Image Support

To use the original `ball-shiny.png` image, you can add SDL_image support:

1. Install SDL_image development libraries
2. Add `#include <SDL3/SDL_image.h>` 
3. Replace the circle drawing with texture rendering
4. Update the Makefile to link with `-lSDL3_image`

### Performance Optimizations

- Use SDL_RenderGeometry for better circle rendering
- Implement spatial partitioning for complex scenes
- Add vsync for smoother animation

### Additional Features

- Sound effects using SDL_mixer
- Multiple balls
- Different ball materials with varying physics properties
- Level editor with custom boundaries

## Technical Notes

- **C99 Standard**: Uses modern C features while maintaining compatibility
- **Memory Management**: Proper cleanup of SDL resources
- **Error Handling**: Comprehensive error checking for SDL operations
- **Frame Rate**: Capped at ~60 FPS for consistent physics

## Comparison with Original

| Feature | Love2D/Lua | C99/SDL3 |
|---------|------------|----------|
| Physics | ✓ Identical | ✓ Identical |
| Graphics | PNG texture | Procedural circle |
| Performance | ~Good | ~Excellent |
| Code Size | ~150 lines | ~320 lines |
| Dependencies | Love2D | SDL3 only |
| Platform | Love2D runtime | Native executable |

The C version provides the same gameplay experience with better performance and smaller deployment size, at the cost of more verbose code and manual resource management.