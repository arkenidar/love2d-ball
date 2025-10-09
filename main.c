#include <SDL3/SDL.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// Define M_PI if not available
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// Constants - matching Love2D version exactly
#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600
#define SCALE 0.25f      // Exact match from Love2D
#define BORDER 10        // Exact match
#define COLUMNS_WIDTH 30 // Exact match
#define ATTENUATION 0.99f
#define GRAVITY 1.0f
#define BALL_ANGLE (M_PI / 32.0f)
#define BOUNCE_DAMPING 0.6f

// Game state structure
typedef struct {
  SDL_Window *window;
  SDL_Renderer *renderer;
  SDL_Texture *ball_texture; // Added back texture support

  // Ball properties
  float x, y;
  float speed_x, speed_y;
  float ball_rotation;
  float ball_rotation_speed;

  // Ball dimensions
  int ball_size; // Changed back to int for texture size
  float ball_radius;

  // Bounds
  float x_min, x_max, y_max;
  float columns_height;

  // Input state
  bool mouse_down;
  int last_mouse_x, last_mouse_y;

  // Game loop control
  bool running;
} GameState;

// Function prototypes
bool init_game(GameState *game);
void cleanup_game(GameState *game);
void handle_events(GameState *game);
void update_game(GameState *game, float dt);
void render_game(GameState *game);
SDL_Texture *load_bmp_texture(SDL_Renderer *renderer, const char *path);

int main(int argc, char *argv[]) {
  (void)argc; // Suppress unused parameter warning
  (void)argv; // Suppress unused parameter warning

  GameState game = {0};

  if (!init_game(&game)) {
    fprintf(stderr, "Failed to initialize game\n");
    return 1;
  }

  // Game loop
  Uint64 last_time = SDL_GetTicks();

  while (game.running) {
    Uint64 current_time = SDL_GetTicks();
    float dt = (current_time - last_time) / 1000.0f;
    last_time = current_time;

    handle_events(&game);
    update_game(&game, dt);
    render_game(&game);

    // Cap at roughly 60 FPS
    SDL_Delay(16);
  }

  cleanup_game(&game);
  return 0;
}

bool init_game(GameState *game) {
  // Initialize SDL
  if (!SDL_Init(SDL_INIT_VIDEO)) {
    fprintf(stderr, "SDL_Init failed: %s\n", SDL_GetError());
    return false;
  }

  // Create window
  game->window = SDL_CreateWindow("Arcade Ball - C99/SDL3", WINDOW_WIDTH,
                                  WINDOW_HEIGHT, SDL_WINDOW_RESIZABLE);

  if (!game->window) {
    fprintf(stderr, "SDL_CreateWindow failed: %s\n", SDL_GetError());
    SDL_Quit();
    return false;
  }

  // Create renderer
  game->renderer = SDL_CreateRenderer(game->window, NULL);
  if (!game->renderer) {
    fprintf(stderr, "SDL_CreateRenderer failed: %s\n", SDL_GetError());
    SDL_DestroyWindow(game->window);
    SDL_Quit();
    return false;
  }

  // Load ball texture
  game->ball_texture = load_bmp_texture(game->renderer, "ball-shiny.bmp");
  if (!game->ball_texture) {
    fprintf(stderr, "Failed to load ball texture\n");
    SDL_DestroyRenderer(game->renderer);
    SDL_DestroyWindow(game->window);
    SDL_Quit();
    return false;
  }

  // Get ball dimensions from texture
  float temp_width, temp_height;
  SDL_GetTextureSize(game->ball_texture, &temp_width, &temp_height);
  game->ball_size = (int)temp_width; // Convert to int
  game->ball_radius = SCALE * game->ball_size / 2.0f;

  // Set bounds - exact match to Love2D version
  game->x_max = 400; // Exact match
  game->y_max = 400; // Exact match
  game->x_min = BORDER + COLUMNS_WIDTH + game->ball_radius;
  game->columns_height = game->y_max + game->ball_radius - BORDER;

  // Initialize ball position and velocity - exact match
  game->x = 250;     // Exact match
  game->y = 150;     // Exact match
  game->speed_x = 5; // Exact match
  game->speed_y = 5; // Exact match
  game->ball_rotation = 0;
  game->ball_rotation_speed = 0;

  // Initialize input state
  game->mouse_down = false;

  // Game is running
  game->running = true;

  return true;
}

void cleanup_game(GameState *game) {
  if (game->ball_texture) {
    SDL_DestroyTexture(game->ball_texture);
  }
  if (game->renderer) {
    SDL_DestroyRenderer(game->renderer);
  }
  if (game->window) {
    SDL_DestroyWindow(game->window);
  }
  SDL_Quit();
}

void handle_events(GameState *game) {
  SDL_Event event;

  while (SDL_PollEvent(&event)) {
    switch (event.type) {
    case SDL_EVENT_QUIT:
      game->running = false;
      break;

    case SDL_EVENT_KEY_DOWN:
      if (event.key.key == SDLK_ESCAPE) {
        game->running = false;
      }
      break;

    case SDL_EVENT_MOUSE_BUTTON_DOWN:
      if (event.button.button == SDL_BUTTON_LEFT) {
        game->mouse_down = true;
        game->last_mouse_x = (int)event.button.x;
        game->last_mouse_y = (int)event.button.y;
      }
      break;

    case SDL_EVENT_MOUSE_BUTTON_UP:
      if (event.button.button == SDL_BUTTON_LEFT) {
        game->mouse_down = false;
      }
      break;

    case SDL_EVENT_MOUSE_MOTION:
      if (game->mouse_down) {
        float dx = event.motion.x - game->last_mouse_x;
        float dy = event.motion.y - game->last_mouse_y;

        game->speed_x += dx / 2.0f;
        game->speed_y += dy / 2.0f;

        game->last_mouse_x = (int)event.motion.x;
        game->last_mouse_y = (int)event.motion.y;
      }
      break;
    }
  }
}

void update_game(GameState *game, float dt) {
  // Horizontal velocity
  float increment_horizontal = dt * game->speed_x * 10.0f;
  game->x += increment_horizontal;

  // Vertical: gravity and vertical velocity
  game->speed_y += GRAVITY;
  float increment_vertical = dt * game->speed_y * 10.0f;
  game->y += increment_vertical;

  // Horizontal rebounds (left and right)
  if (game->x < game->x_min) {
    game->x = game->x_min;
    game->speed_x *= BOUNCE_DAMPING;
    game->speed_x = -game->speed_x;
  }
  if (game->x > game->x_max) {
    game->x = game->x_max;
    game->speed_x *= BOUNCE_DAMPING;
    game->speed_x = -game->speed_x;
  }

  // Vertical rebound (bottom)
  if (game->y > game->y_max) {
    game->y = game->y_max;
    game->speed_y *= BOUNCE_DAMPING;
    game->speed_y = -game->speed_y;
  }

  // Angular speed calculation
  float ball_rotation_speed_cumulative = 0;

  // Friction (bottom, horizontal)
  if (fabsf(game->y - game->y_max) < 0.1f) {
    game->speed_x *= ATTENUATION;
    ball_rotation_speed_cumulative += BALL_ANGLE * game->speed_x;
  }

  // Friction (left, vertical)
  if (fabsf(game->x - game->x_min) < 0.1f) {
    game->speed_y *= ATTENUATION;
    ball_rotation_speed_cumulative += BALL_ANGLE * game->speed_y;
  }

  // Friction (right, vertical)
  if (fabsf(game->x - game->x_max) < 0.1f) {
    game->speed_y *= ATTENUATION;
    ball_rotation_speed_cumulative -= BALL_ANGLE * game->speed_y;
  }

  // Ball rotation
  if (fabsf(ball_rotation_speed_cumulative) > 0.001f) {
    game->ball_rotation_speed = ball_rotation_speed_cumulative;
  }
  game->ball_rotation_speed *= ATTENUATION;
  game->ball_rotation += dt * game->ball_rotation_speed;
}

void render_game(GameState *game) {
  // Clear screen with black
  SDL_SetRenderDrawColor(game->renderer, 0, 0, 0, 255);
  SDL_RenderClear(game->renderer);

  // Set drawing color to white for boundaries
  SDL_SetRenderDrawColor(game->renderer, 255, 255, 255, 255);

  // Draw vertical columns (bounding walls)
  SDL_FRect left_column = {BORDER, BORDER, COLUMNS_WIDTH, game->columns_height};
  SDL_RenderFillRect(game->renderer, &left_column);

  SDL_FRect right_column = {game->x_max + game->ball_radius, BORDER,
                            COLUMNS_WIDTH, game->columns_height};
  SDL_RenderFillRect(game->renderer, &right_column);

  // Draw horizontal floor
  SDL_FRect floor = {BORDER, game->columns_height + BORDER,
                     game->x_max + game->ball_radius + COLUMNS_WIDTH - BORDER,
                     COLUMNS_WIDTH};
  SDL_RenderFillRect(game->renderer, &floor);

  // Draw ball texture with rotation
  SDL_FRect ball_dest = {game->x - game->ball_radius,
                         game->y - game->ball_radius, game->ball_size * SCALE,
                         game->ball_size * SCALE};

  // Convert rotation from radians to degrees
  double rotation_degrees = game->ball_rotation * (180.0 / M_PI);

  // Center point for rotation
  SDL_FPoint center = {game->ball_size * SCALE / 2.0f,
                       game->ball_size * SCALE / 2.0f};

  SDL_RenderTextureRotated(game->renderer, game->ball_texture, NULL, &ball_dest,
                           rotation_degrees, &center, SDL_FLIP_NONE);

  // Present the frame
  SDL_RenderPresent(game->renderer);
}

SDL_Texture *load_bmp_texture(SDL_Renderer *renderer, const char *path) {
  SDL_Surface *surface = SDL_LoadBMP(path);
  if (!surface) {
    fprintf(stderr, "SDL_LoadBMP failed for %s: %s\n", path, SDL_GetError());
    return NULL;
  }

  SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, surface);
  SDL_DestroySurface(surface);

  if (!texture) {
    fprintf(stderr, "SDL_CreateTextureFromSurface failed: %s\n",
            SDL_GetError());
    return NULL;
  }

  // Enable alpha blending for the texture
  SDL_SetTextureBlendMode(texture, SDL_BLENDMODE_BLEND);

  return texture;
}