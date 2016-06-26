require 'opengl'
require 'glfw'
require_relative '../nuklear'

OpenGL.load_lib()
GLFW.load_lib()
Nuklear.load_lib('libnuklear.dylib')

include OpenGL
include GLFW
include Nuklear

# Press ESC to exit.
key_callback = GLFW::create_callback(:GLFWkeyfun) do |window_handle, key, scancode, action, mods|
  if key == GLFW_KEY_ESCAPE && action == GLFW_PRESS
    glfwSetWindowShouldClose(window_handle, 1)
  end
end

if __FILE__ == $0
  glfwInit()

  window = glfwCreateWindow( 640, 480, "Simple example", nil, nil )
  glfwMakeContextCurrent( window )
  glfwSetKeyCallback( window, key_callback )

  nulldev = NK_DRAW_NULL_TEXTURE.new
  ctx = NK_CONTEXT.new

  nk_init_default(ctx, nil)
  cmds = NK_BUFFER.new
  nk_buffer_init_default(cmds)

  atlas = NK_FONT_ATLAS.new
  nk_font_atlas_init_default(atlas)
  nk_font_atlas_begin(atlas)
  w = ' ' * 4
  h = ' ' * 4
  image = nk_font_atlas_bake(atlas, w, h, NK_FONT_ATLAS_FORMAT[:NK_FONT_ATLAS_RGBA32])

  font_tex = ' ' * 4
  glGenTextures(1, font_tex)
  glBindTexture(GL_TEXTURE_2D, font_tex.unpack('L')[0])
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w.unpack('L')[0], h.unpack('L')[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, image)
  nk_font_atlas_end(atlas, nk_handle_id(font_tex.unpack('L')[0]), nulldev)
  if atlas[:default_font].null? == false
    fnt = NK_FONT.new(atlas[:default_font])
    nk_style_set_font(ctx, fnt[:handle])
  end

  glClearColor( 0.25, 0.55, 0.85, 0.0 )

  while glfwWindowShouldClose( window ) == 0
    glfwPollEvents()

    # 3D
    width_ptr = ' ' * 8
    height_ptr = ' ' * 8
    glfwGetFramebufferSize(window, width_ptr, height_ptr)
    width = width_ptr.unpack('L')[0]
    height = height_ptr.unpack('L')[0]
    ratio = width.to_f / height.to_f

    glViewport(0, 0, width, height)
    glClear(GL_COLOR_BUFFER_BIT)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
    glMatrixMode(GL_MODELVIEW)

    glLoadIdentity()
    glRotatef(glfwGetTime() * 50.0, 0.0, 0.0, 1.0)

    glBegin(GL_TRIANGLES)
    glColor3f(1.0, 0.0, 0.0)
    glVertex3f(-0.6, -0.4, 0.0)
    glColor3f(0.0, 1.0, 0.0)
    glVertex3f(0.6, -0.4, 0.0)
    glColor3f(0.0, 0.0, 1.0)
    glVertex3f(0.0, 0.6, 0.0)
    glEnd()

    # 2D
    rect = NK_RECT.new
    rect[:x] = 50.0
    rect[:y] = 50.0
    rect[:w] = 230.0
    rect[:h] = 250.0
    begin
      # Setup widgets
      layout = NK_PANEL.new
      r = nk_begin(ctx, layout, "Nuklear Ruby Bindings", rect,
                   NK_PANEL_FLAGS[:NK_WINDOW_BORDER]|
                   NK_PANEL_FLAGS[:NK_WINDOW_MOVABLE]|
                   NK_PANEL_FLAGS[:NK_WINDOW_SCALABLE]|
                   NK_PANEL_FLAGS[:NK_WINDOW_MINIMIZABLE]|
                   NK_PANEL_FLAGS[:NK_WINDOW_TITLE])
      if r != 0
        # Setup Widgets Here
      end
      nk_end(ctx)
    end

    begin
      # Render
      glPushAttrib(GL_ENABLE_BIT|GL_COLOR_BUFFER_BIT|GL_TRANSFORM_BIT)
      glDisable(GL_CULL_FACE)
      glDisable(GL_DEPTH_TEST)
      glEnable(GL_SCISSOR_TEST)
      glEnable(GL_BLEND)
      glEnable(GL_TEXTURE_2D)
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

      glViewport(0,0,width,height)
      glMatrixMode(GL_PROJECTION)
      glPushMatrix()
      glLoadIdentity()
      glOrtho(0.0, width, height, 0.0, -1.0, 1.0)
      glMatrixMode(GL_MODELVIEW)
      glPushMatrix()
      glLoadIdentity()

      glEnableClientState(GL_VERTEX_ARRAY)
      glEnableClientState(GL_TEXTURE_COORD_ARRAY)
      glEnableClientState(GL_COLOR_ARRAY)
      begin
        vs = NK_DRAW_VERTEX.size
        vp = NK_DRAW_VERTEX.offset_of(:position)
        vt = NK_DRAW_VERTEX.offset_of(:uv)
        vc = NK_DRAW_VERTEX.offset_of(:col)

        config = NK_CONVERT_CONFIG.new
        config[:global_alpha] = 1.0
        config[:shape_AA] = NK_ANTI_ALIASING[:NK_ANTI_ALIASING_ON]
        config[:line_AA] = NK_ANTI_ALIASING[:NK_ANTI_ALIASING_ON]
        config[:circle_segment_count] = 22
        config[:curve_segment_count] = 22
        config[:arc_segment_count] = 22
        config[:null] = nulldev

        vbuf = NK_BUFFER.new
        ebuf = NK_BUFFER.new
        nk_buffer_init_default(vbuf)
        nk_buffer_init_default(ebuf)
        nk_convert(ctx, cmds, vbuf, ebuf, config)
        vertices = nk_buffer_memory_const(vbuf)
        glVertexPointer(2, GL_FLOAT, vs, (vertices+vp))
        glTexCoordPointer(2, GL_FLOAT, vs, (vertices+vt))
        glColorPointer(4, GL_UNSIGNED_BYTE, vs, (vertices+vc))

        offset = nk_buffer_memory_const(ebuf)
        begin
          # draw widgets here
          nk_draw_foreach(ctx, cmds) do |cmd_ptr|
            window_height = 480.0
            fb_scale_x = 1.0
            fb_scale_y = 1.0
            cmd = NK_DRAW_COMMAND.new(cmd_ptr)
            next if cmd[:elem_count] == 0
            glBindTexture(GL_TEXTURE_2D, cmd[:texture][:id])
            glScissor(
                (cmd[:clip_rect][:x] * fb_scale_x).to_i,
                ((window_height - (cmd[:clip_rect][:y] + cmd[:clip_rect][:h])).to_i * fb_scale_y).to_i,
                (cmd[:clip_rect][:w] * fb_scale_x).to_i,
                (cmd[:clip_rect][:h] * fb_scale_y)).to_i
            glDrawElements(GL_TRIANGLES, cmd[:elem_count], GL_UNSIGNED_SHORT, offset);
            offset += cmd[:elem_count]
          end
        end
        nk_clear(ctx)
        nk_buffer_free(vbuf)
        nk_buffer_free(ebuf)
      end
      glDisableClientState(GL_VERTEX_ARRAY)
      glDisableClientState(GL_TEXTURE_COORD_ARRAY)
      glDisableClientState(GL_COLOR_ARRAY)

      glDisable(GL_CULL_FACE)
      glDisable(GL_DEPTH_TEST)
      glDisable(GL_SCISSOR_TEST)
      glDisable(GL_BLEND)
      glDisable(GL_TEXTURE_2D)

      glBindTexture(GL_TEXTURE_2D, 0)
      glMatrixMode(GL_MODELVIEW)
      glPopMatrix()
      glMatrixMode(GL_PROJECTION)
      glPopMatrix()
      glPopAttrib()
    end

    glfwSwapBuffers( window )
  end

  nk_buffer_free(cmds)
  nk_free(ctx)

  glfwDestroyWindow( window )
  glfwTerminate()
end
