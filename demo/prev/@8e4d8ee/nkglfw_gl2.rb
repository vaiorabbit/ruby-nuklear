class NKGL2Device

  attr_accessor :cmds, :null, :vbo, :vao, :ebo, :prog, :vert_shdr, :frag_shdr,
                :attrib_pos, :attrib_uv, :attrib_col, :uniform_tex, :uniform_proj, :font_tex

  def initialize
    @cmds = nil
    @null = nil
    @font_tex = 0
  end

  def create
    @null = NK_DRAW_NULL_TEXTURE.new
    @cmds = NK_BUFFER.new
    nk_buffer_init_default(@cmds)
  end

  def destroy
    glDeleteTextures(1, [@font_tex].pack('L'))
    nk_buffer_free(@cmds)
  end

  def upload_atlas(image, width, height)
    font_tex_buf = ' ' * 4
    glGenTextures(1, font_tex_buf);
    @font_tex = font_tex_buf.unpack('L')[0]
    glBindTexture(GL_TEXTURE_2D, @font_tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image);
  end

end # class NKGL3Device


NK_GLFW_TEXT_MAX = 256

class NKGLFWContext

  attr_accessor :win, :width, :height, :display_width, :display_height,
                :ogl, :ctx, :atlas, :fb_scale, :text, :text_len, :scroll

  def initialize
    @win = nil
    @width = 0
    @height = 0
    @display_width = 0
    @display_height = 0
    @ogl = nil
    @ctx = nil
    @atlas = nil
    @fb_scale = NK_VEC2.new
    @text = Array.new(NK_GLFW_TEXT_MAX) { 0 }
    @text_len = 0
    @scroll = 0.0
  end

  def create(win, install_callback: false)
    @win = win
    if install_callback
      # glfwSetScrollCallback(win, nk_gflw3_scroll_callback)
      # glfwSetCharCallback(win, nk_glfw3_char_callback)
    end

    @ctx = NK_CONTEXT.new
    nk_init_default(@ctx, nil)
    # @ctx.clip.copy = nk_glfw3_clipbard_copy;
    # @ctx.clip.paste = nk_glfw3_clipbard_paste;
    # @ctx.clip.userdata = nk_handle_ptr(0);
    @ogl = NKGL2Device.new
    @ogl.create
    return @ctx
  end

  def destroy
    nk_font_atlas_clear(@atlas)
    nk_free(@ctx)
    @ogl.destroy
  end

  def font_stash_begin
    @atlas = NK_FONT_ATLAS.new
    nk_font_atlas_init_default(@atlas)
    nk_font_atlas_begin(@atlas)
    return @atlas
  end

  def font_stash_end(loaded_font)
    w = ' ' * 4
    h = ' ' * 4
    image = nk_font_atlas_bake(atlas, w, h, NK_FONT_ATLAS_FORMAT[:NK_FONT_ATLAS_RGBA32])
    # Upload atlas
    @ogl.upload_atlas(image, w.unpack('L')[0], h.unpack('L')[0])
    nk_font_atlas_end(@atlas, nk_handle_id(@ogl.font_tex), @ogl.null)
    if @atlas[:default_font].null? == false
      default_fnt = NK_FONT.new(atlas[:default_font])
      nk_style_set_font(ctx, default_fnt[:handle])
    else
      nk_style_set_font(ctx, loaded_font[:handle])
    end
  end

  def render(aa, max_vertex_buffer, max_element_buffer)
    glPushAttrib(GL_ENABLE_BIT|GL_COLOR_BUFFER_BIT|GL_TRANSFORM_BIT)
    glDisable(GL_CULL_FACE)
    glDisable(GL_DEPTH_TEST)
    glEnable(GL_SCISSOR_TEST)
    glEnable(GL_BLEND)
    glEnable(GL_TEXTURE_2D)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

    glViewport(0,0, @display_width.to_i, @display_height.to_i)
    glMatrixMode(GL_PROJECTION)
    glPushMatrix()
    glLoadIdentity()
    glOrtho(0.0, @width, @height, 0.0, -1.0, 1.0)
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
      config[:null] = @ogl.null

      vbuf = NK_BUFFER.new
      ebuf = NK_BUFFER.new
      nk_buffer_init_default(vbuf)
      nk_buffer_init_default(ebuf)
      nk_convert(@ctx, @ogl.cmds, vbuf, ebuf, config)
      vertices = nk_buffer_memory_const(vbuf)
      glVertexPointer(2, GL_FLOAT, vs, (vertices+vp))
      glTexCoordPointer(2, GL_FLOAT, vs, (vertices+vt))
      glColorPointer(4, GL_UNSIGNED_BYTE, vs, (vertices+vc))

      offset = nk_buffer_memory_const(ebuf) # GL2
      # offset = FFI::Pointer::NULL # GL3
      begin
        # draw widgets here
        nk_draw_foreach(@ctx, @ogl.cmds) do |cmd|
          next if cmd[:elem_count] == 0
          glBindTexture(GL_TEXTURE_2D, cmd[:texture][:id])
          glScissor(
            (cmd[:clip_rect][:x] * @fb_scale[:x]).to_i,
            (($nkglfw.display_height - (cmd[:clip_rect][:y] + cmd[:clip_rect][:h])).to_i * @fb_scale[:y]).to_i,
            (cmd[:clip_rect][:w] * @fb_scale[:x]).to_i,
            (cmd[:clip_rect][:h] * @fb_scale[:y]).to_i)
          glDrawElements(GL_TRIANGLES, cmd[:elem_count], GL_UNSIGNED_SHORT, offset);
          offset += (FFI.type_size(:ushort) * cmd[:elem_count]) # NOTE : FFI.type_size(:ushort) == size of :nk_draw_index
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

  def new_frame
    fb_width_ptr = ' ' * 8
    fb_height_ptr = ' ' * 8
    win_width_ptr = ' ' * 8
    win_height_ptr = ' ' * 8
    glfwGetFramebufferSize(@win, fb_width_ptr, fb_height_ptr)
    @display_width = fb_width_ptr.unpack('L')[0]
    @display_height = fb_height_ptr.unpack('L')[0]

    glfwGetWindowSize(@win, win_width_ptr, win_height_ptr)
    @width = win_width_ptr.unpack('L')[0]
    @height = win_height_ptr.unpack('L')[0]

    @fb_scale[:x] = @display_width / @width.to_f
    @fb_scale[:y] = @display_height / @height.to_f

    nk_input_begin(ctx)
    @text_len.times do |i|
      nk_input_unicode(@ctx, @text[i])
    end
    if ctx[:input][:mouse][:grab] != 0
      glfwSetInputMode(@win, GLFW_CURSOR, GLFW_CURSOR_HIDDEN)
    elsif ctx[:input][:mouse][:ungrab] != 0
      glfwSetInputMode(@win, GLFW_CURSOR, GLFW_CURSOR_NORMAL)
    end

    # TODO nk_input_key <-> glfwGetKey

    cursor_x_ptr = ' ' * 8
    cursor_y_ptr = ' ' * 8
    glfwGetCursorPos(@win, cursor_x_ptr, cursor_y_ptr)
    cursor_x = cursor_x_ptr.unpack('D')[0]
    cursor_y = cursor_y_ptr.unpack('D')[0]
    nk_input_motion(@ctx, cursor_x.to_i, cursor_y.to_i)
    if @ctx[:input][:mouse][:grabbed] != 0
      glfwSetCursorPos(@win, @ctx[:input][:mouse][:prev][:x], @ctx[:input][:mouse][:prev][:y])
      @ctx[:input][:mouse][:pos][:x] = @ctx[:input][:mouse][:prev][:x]
      @ctx[:input][:mouse][:pos][:y] = @ctx[:input][:mouse][:prev][:y]
    end
    nk_input_button(@ctx, NK_BUTTONS[:NK_BUTTON_LEFT], cursor_x, cursor_y, glfwGetMouseButton(@win, ((GLFW_MOUSE_BUTTON_LEFT) == GLFW_PRESS) ? 1 : 0))
    nk_input_button(@ctx, NK_BUTTONS[:NK_BUTTON_MIDDLE], cursor_x, cursor_y, glfwGetMouseButton(@win, ((GLFW_MOUSE_BUTTON_MIDDLE) == GLFW_PRESS) ? 1 : 0))
    nk_input_button(@ctx, NK_BUTTONS[:NK_BUTTON_RIGHT], cursor_x, cursor_y, glfwGetMouseButton(@win, ((GLFW_MOUSE_BUTTON_RIGHT) == GLFW_PRESS) ? 1 : 0))
    nk_input_end(@ctx)
    @text_len = 0
    @scroll = 0
  end

end # class NKGLFWContext
