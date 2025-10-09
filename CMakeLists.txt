cmake_minimum_required(VERSION 3.16)
project(love2d-ball-sdl C)

# Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Add compile options
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -pedantic)
endif()

# Option to use system SDL3 or fetch from git
option(USE_SYSTEM_SDL3 "Use system-installed SDL3 instead of fetching from git" OFF)

if(USE_SYSTEM_SDL3)
    # Try to find system SDL3 first
    find_package(SDL3 QUIET)
    if(NOT SDL3_FOUND)
        # Try pkg-config as fallback
        find_package(PkgConfig QUIET)
        if(PkgConfig_FOUND)
            pkg_check_modules(SDL3 QUIET sdl3)
        endif()
    endif()
    
    if(NOT SDL3_FOUND)
        message(FATAL_ERROR "System SDL3 not found. Install SDL3 or set USE_SYSTEM_SDL3=OFF to fetch from git.")
    endif()
else()
    # Include FetchContent module for downloading SDL3
    include(FetchContent)
    
    # Fetch SDL3 from GitHub
    FetchContent_Declare(
        SDL3
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG        main  # Use main branch for latest features
        GIT_SHALLOW    TRUE
    )
    
    # Configure SDL3 options
    set(SDL_SHARED ON CACHE BOOL "Build SDL3 shared library")
    set(SDL_STATIC OFF CACHE BOOL "Build SDL3 static library") 
    set(SDL_TEST_LIBRARY OFF CACHE BOOL "Build SDL3 test library")
    set(SDL_TESTS OFF CACHE BOOL "Build SDL3 tests")
    
    # Make SDL3 available
    FetchContent_MakeAvailable(SDL3)
endif()

# Create executable
add_executable(ball_game main.c)

# Link SDL3
if(USE_SYSTEM_SDL3)
    target_link_libraries(ball_game PRIVATE ${SDL3_LIBRARIES})
    target_include_directories(ball_game PRIVATE ${SDL3_INCLUDE_DIRS})
    target_compile_options(ball_game PRIVATE ${SDL3_CFLAGS_OTHER})
else()
    target_link_libraries(ball_game PRIVATE SDL3::SDL3)
endif()

# Link math library on Unix systems
if(UNIX AND NOT APPLE)
    target_link_libraries(ball_game PRIVATE m)
endif()

# Copy assets to build directory
configure_file(${CMAKE_SOURCE_DIR}/ball-shiny.bmp ${CMAKE_BINARY_DIR}/ball-shiny.bmp COPYONLY)

# Set output directory for better organization
set_target_properties(ball_game PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Create a custom target to copy assets to the bin directory
add_custom_command(TARGET ball_game POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_SOURCE_DIR}/ball-shiny.bmp
        ${CMAKE_BINARY_DIR}/bin/ball-shiny.bmp
)

# Optional: Add install target
install(TARGETS ball_game
    RUNTIME DESTINATION bin
)

install(FILES ball-shiny.bmp
    DESTINATION bin
)

# Print build information
message(STATUS "Building love2d-ball-sdl")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
if(USE_SYSTEM_SDL3)
    message(STATUS "Using system SDL3")
else()
    message(STATUS "SDL3 will be fetched from: https://github.com/libsdl-org/SDL.git")
endif()