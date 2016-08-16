# coding: utf-8
require 'opengl'
require 'glfw'
require_relative '../nuklear'
require_relative './nkglfw_gl3'

OpenGL.load_lib()
GLFW.load_lib()
Nuklear.load_lib('libnuklear.dylib')

include OpenGL
include GLFW
include Nuklear

$nkglfw = NKGLFWContext.new

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 480

MAX_VERTEX_BUFFER = 512 * 1024
MAX_ELEMENT_BUFFER = 128 * 1024

# Press ESC to exit.
key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
  if key == GLFW_KEY_ESCAPE && action == GLFW_PRESS
    glfwSetWindowShouldClose(window_handle, 1)
  end
end

class NKCanvas
  attr_accessor :layout, :painter, :item_spacing, :panel_padding
  def initialize
    @layout = NK_PANEL.new
    @painter = nil
    @item_spacing = NK_VEC2.new
    @panel_padding = NK_VEC2.new
  end

  def begin_register(ctx, x, y, width, height)
    @panel_padding = ctx[:style][:window][:padding]
    @item_spacing = ctx[:style][:window][:spacing]
    ctx[:style][:window][:spacing] = NK_VEC2.new
    ctx[:style][:window][:spacing][:x] = 0.0
    ctx[:style][:window][:spacing][:y] = 0.0
    ctx[:style][:window][:padding] = NK_VEC2.new
    ctx[:style][:window][:padding][:x] = 0.0
    ctx[:style][:window][:padding][:y] = 0.0

    rect = NK_RECT.new.set_params(x, y, width, height)
    nk_begin(ctx, @layout, "Window", rect, NK_PANEL_FLAGS[:NK_WINDOW_NO_SCROLLBAR])
    nk_window_set_bounds(ctx, rect)

    begin
      total_space = nk_window_get_content_region(ctx)
      nk_layout_row_dynamic(ctx, total_space[:h], 1)
      nk_widget(total_space, ctx)
      @painter = nk_window_get_canvas(ctx)
    end
  end

  def end_register(ctx)
    nk_end(ctx)
    ctx[:style][:window][:spacing] = @item_spacing
    ctx[:style][:window][:padding] = @panel_padding
  end
end

class NK_RECT
  def set_params(x, y, w, h)
    self[:x] = x;  self[:y] = y;  self[:w] = w;  self[:h] = h
    return self
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
  window = glfwCreateWindow( WINDOW_WIDTH, WINDOW_HEIGHT, "Ruby-Nuklear Canvas Demo", nil, nil )
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
    loaded_font_ptr = nk_font_atlas_add_from_memory(atlas, ttf, ttf_size, 22, nil)
    loaded_font = NK_FONT.new(loaded_font_ptr)
  end
  $nkglfw.font_stash_end(loaded_font)

  background = nk_rgb(64, 140, 216)

  while glfwWindowShouldClose( window ) == 0
    glfwPollEvents()
    $nkglfw.new_frame()

    canvas = NKCanvas.new
    canvas.begin_register(ctx, 0, 0, $nkglfw.width, $nkglfw.height)
    rect = NK_RECT.new
    rect.set_params(0, 0, $nkglfw.width, $nkglfw.height)
    nk_fill_rect(canvas.painter, rect, 0, nk_rgb(150, 150, 150))
    rect.set_params(15, 15, 210, 210)
    nk_fill_rect(canvas.painter, rect, 5, nk_rgb(247, 230, 154))
    rect.set_params(20, 20, 200, 200)
    nk_fill_rect(canvas.painter, rect, 5, nk_rgb(188, 174, 118))
    rect.set_params(30, 30, 150, 20)
    nk_draw_text(canvas.painter, rect, "Text to draw", 12, loaded_font[:handle], nk_rgb(188, 174, 118), nk_rgb(0, 0, 0))
    rect.set_params(250, 20, 100, 100)
    nk_fill_rect(canvas.painter, rect, 0, nk_rgb(0, 0, 255))
    rect.set_params(20, 250, 100, 100)
    nk_fill_circle(canvas.painter, rect, nk_rgb(255,0,0))
    nk_fill_triangle(canvas.painter, 250, 250, 350, 250, 300, 350, nk_rgb(0, 255, 0))
    nk_fill_arc(canvas.painter, 300, 180, 50, 0, 3.141592654 * 3.0 / 4.0, nk_rgb(255, 255, 0))

    points = [200, 250, 250, 350, 225, 350, 200, 300, 175, 350, 150, 350].pack('F12')
    nk_fill_polygon(canvas.painter, points, 6, nk_rgb(255, 255, 255))

    nk_stroke_line(canvas.painter, 15, 10, 200, 10, 2.0, nk_rgb(189, 45, 75))
    rect.set_params(370, 20, 100, 100)
    nk_stroke_rect(canvas.painter, rect, 10, 3, nk_rgb(0, 0, 255))
    nk_stroke_curve(canvas.painter, 380, 200, 405, 270, 455, 120, 480, 200, 2, nk_rgb(0, 150, 220))
    rect.set_params(20, 370, 100, 100)
    nk_stroke_circle(canvas.painter, rect, 5, nk_rgb(0, 255, 120))
    nk_stroke_triangle(canvas.painter, 370, 250, 470, 250, 420, 350, 6, nk_rgb(255, 0, 143))

    canvas.end_register(ctx)

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
