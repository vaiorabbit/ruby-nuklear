# coding: utf-8
require 'opengl'
require 'glfw'
require_relative '../nuklear'
require_relative './nkglfw_gl3'
require_relative './overview'

OpenGL.load_lib()
GLFW.load_lib()
Nuklear.load_lib('libnuklear.dylib')

include OpenGL
include GLFW
include Nuklear

$nkglfw = NKGLFWContext.new

WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 800

MAX_VERTEX_BUFFER = 512 * 1024
MAX_ELEMENT_BUFFER = 128 * 1024

# Press ESC to exit.
key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
  if key == GLFW_KEY_ESCAPE && action == GLFW_PRESS
    glfwSetWindowShouldClose(window_handle, 1)
  end
end

if __FILE__ == $0
  glfwInit()

  if OpenGL.get_platform == :OPENGL_PLATFORM_MACOSX
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)
  end
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
  window = glfwCreateWindow( WINDOW_WIDTH, WINDOW_HEIGHT, "Ruby-Nuklear Demo (GL3)", nil, nil )
  glfwMakeContextCurrent( window )

  glfwSetKeyCallback( window, key_callback )

  ctx = $nkglfw.create(window, install_callback: false )
  atlas = $nkglfw.font_stash_begin()

  # Load fonts you like
  loaded_font = nil
  File.open("../nuklear/extra_font/Roboto-Bold.ttf", "rb") do |ttf_file|
    ttf_size = ttf_file.size()
    ttf = FFI::MemoryPointer.new(:uint8, ttf_size)
    content = ttf_file.read
    ttf.put_bytes(0, content)
    loaded_font = nk_font_atlas_add_from_memory(atlas, ttf, ttf_size, 14, nil)
  end
  $nkglfw.font_stash_end(loaded_font)

  background = nk_rgb(64, 140, 216)

  compression_property = FFI::MemoryPointer.new(:int32, 1)
  compression_property.put_int32(0, 20)

  difficulty_option = FFI::MemoryPointer.new(:int32, 1)
  difficulty_option.put_int32(0, 0)

  while glfwWindowShouldClose( window ) == 0
    # Input
    glfwPollEvents()
    $nkglfw.new_frame()

    # GUI
    overview(ctx)

    # Render
    glViewport(0, 0, $nkglfw.width, $nkglfw.height)
    glClear(GL_COLOR_BUFFER_BIT)
    glClearColor( background[:r] / 255.0, background[:g] / 255.0, background[:b] / 255.0, 1.0 )
    $nkglfw.render(NK_ANTI_ALIASING[:NK_ANTI_ALIASING_ON], MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)

    glfwSwapBuffers( window )
  end

  $nkglfw.destroy()

  glfwDestroyWindow( window )
  glfwTerminate()
end
