class NKGL3Device

  attr_accessor :cmds, :null, :vbo, :vao, :ebo, :prog, :vert_shdr, :frag_shdr,
                :attrib_pos, :attrib_uv, :attrib_col, :uniform_tex, :uniform_proj, :font_tex

  def initialize
    @cmds = nil
    @null = nil
    @vbo = 0
    @vao = 0
    @ebo = 0
    @prog = 0
    @vert_shdr = 0
    @frag_shdr = 0
    @attrib_pos = 0
    @attrib_uv = 0
    @attrib_col = 0
    @uniform_tex = 0
    @uniform_proj = 0
    @font_tex = 0
  end

  def create
    init_nk()
    init_gl()
  end

  def init_nk
    @null = NK_DRAW_NULL_TEXTURE.new

    @cmds = NK_BUFFER.new
    nk_buffer_init_default(@cmds)
  end

  def init_gl
    vertex_shader = <<-'VPSRC'
        #version 150
        uniform mat4 ProjMtx;
        in vec2 Position;
        in vec2 TexCoord;
        in vec4 Color;
        out vec2 Frag_UV;
        out vec4 Frag_Color;
        void main() {
            Frag_UV = TexCoord;
            Frag_Color = Color;
            gl_Position = ProjMtx * vec4(Position.xy, 0, 1);
        }
        VPSRC

    fragment_shader = <<-'FPSRC'
        #version 150
        precision mediump float;
        uniform sampler2D Texture;
        in vec2 Frag_UV;
        in vec4 Frag_Color;
        out vec4 Out_Color;
        void main(){
            Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
        }
        FPSRC

    @prog = glCreateProgram()
    @vert_shdr = glCreateShader(GL_VERTEX_SHADER)
    @frag_shdr = glCreateShader(GL_FRAGMENT_SHADER)
    glShaderSource(@vert_shdr, 1, [vertex_shader].pack('p'), [vertex_shader.length].pack('I'))
    glShaderSource(@frag_shdr, 1, [fragment_shader].pack('p'), [fragment_shader.length].pack('I'))
    glCompileShader(@vert_shdr)
    glCompileShader(@frag_shdr)
    # status = ' ' * 4
    # status_buf = ' ' * 4
    # glGetShaderiv(@vert_shdr, GL_COMPILE_STATUS, status_buf)
    # status = status_buf.unpack('L')[0]
    # p status
    # if status == 0
    #   infoLog = ' ' * 64
    #   glGetShaderInfoLog(@vert_shdr, 64, nil, infoLog)
    #   puts "Vertex Shader InfoLog:\n#{infoLog}\n"
    # end
    # glGetShaderiv(@frag_shdr, GL_COMPILE_STATUS, status_buf)
    # status = status_buf.unpack('L')[0]
    # p status
    # if status == 0
    #   infoLog = ' ' * 64
    #   glGetShaderInfoLog(@frag_shdr, 64, nil, infoLog)
    #   puts "Fragment Shader InfoLog:\n#{infoLog}\n"
    # end
    glAttachShader(@prog, @vert_shdr)
    glAttachShader(@prog, @frag_shdr)
    glLinkProgram(@prog)
    # glGetProgramiv(@prog, GL_LINK_STATUS, status_buf)
    # status = status_buf.unpack('L')[0]
    # p status

    @uniform_tex = glGetUniformLocation(@prog, "Texture")

    @uniform_proj = glGetUniformLocation(@prog, "ProjMtx")
    @attrib_pos = glGetAttribLocation(@prog, "Position")
    @attrib_uv = glGetAttribLocation(@prog, "TexCoord")
    @attrib_col = glGetAttribLocation(@prog, "Color")
    # buffer setup
    vs = NK_DRAW_VERTEX.size # sizeof(struct nk_draw_vertex)
    vp = NK_DRAW_VERTEX.offset_of(:position)
    vt = NK_DRAW_VERTEX.offset_of(:uv)
    vc = NK_DRAW_VERTEX.offset_of(:col)

    buf = ' ' * 4 * 2
    glGenBuffers(2, buf)
    ids = buf.unpack('L2')
    @vbo = ids[0]
    @ebo = ids[1]
    glGenVertexArrays(1, buf)
    @vao = buf.unpack('L')[0]

    glBindVertexArray(@vao)
    glBindBuffer(GL_ARRAY_BUFFER, @vbo)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @ebo)

    glEnableVertexAttribArray(@attrib_pos)
    glEnableVertexAttribArray(@attrib_uv)
    glEnableVertexAttribArray(@attrib_col)

    glVertexAttribPointer(@attrib_pos, 2, GL_FLOAT, GL_FALSE, vs, vp)
    glVertexAttribPointer(@attrib_uv, 2, GL_FLOAT, GL_FALSE, vs, vt)
    glVertexAttribPointer(@attrib_col, 4, GL_UNSIGNED_BYTE, GL_TRUE, vs, vc)

    glBindTexture(GL_TEXTURE_2D, 0)
    glBindBuffer(GL_ARRAY_BUFFER, 0)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
    glBindVertexArray(0)
  end

  def destroy
    glDetachShader(@prog, @vert_shdr)
    glDetachShader(@prog, @frag_shdr)
    glDeleteShader(@vert_shdr)
    glDeleteShader(@frag_shdr)
    glDeleteProgram(@prog)
    glDeleteTextures(1, [@font_tex].pack('L'))
    glDeleteBuffers(2, [@vbo, @ebo].pack('L2'))
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
    @ogl = NKGL3Device.new
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
    ortho = [2.0 / @width.to_f, 0.0, 0.0, 0.0,
             0.0, -2.0 / @height.to_f, 0.0, 0.0,
             0.0, 0.0, -1.0, 0.0,
             -1.0 ,1.0, 0.0, 1.0].pack('F16')

    glEnable(GL_BLEND)
    glBlendEquation(GL_FUNC_ADD)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glDisable(GL_CULL_FACE)
    glDisable(GL_DEPTH_TEST)
    glEnable(GL_SCISSOR_TEST)
    glActiveTexture(GL_TEXTURE0)

    glUseProgram(@ogl.prog)
    glUniform1i(@ogl.uniform_tex, 0)
    glUniformMatrix4fv(@ogl.uniform_proj, 1, GL_FALSE, ortho)
    glViewport(0,0, @display_width.to_i, @display_height.to_i)

    begin
      glBindVertexArray(@ogl.vao)
      glBindBuffer(GL_ARRAY_BUFFER, @ogl.vbo)
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @ogl.ebo)

      glBufferData(GL_ARRAY_BUFFER, max_vertex_buffer, nil, GL_STREAM_DRAW)
      glBufferData(GL_ELEMENT_ARRAY_BUFFER, max_element_buffer, nil, GL_STREAM_DRAW)

      vertices_fiddle_ptr = glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY)
      elements_fiddle_ptr = glMapBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY)
      vertices = FFI::Pointer.new(:pointer, vertices_fiddle_ptr.to_i)
      elements = FFI::Pointer.new(:pointer, elements_fiddle_ptr.to_i)
      begin
        config = NK_CONVERT_CONFIG.new
        config[:global_alpha] = 1.0
        config[:shape_AA] = aa # NK_ANTI_ALIASING[:NK_ANTI_ALIASING_ON], etc.
        config[:line_AA] = aa # NK_ANTI_ALIASING[:NK_ANTI_ALIASING_ON], etc.
        config[:circle_segment_count] = 22
        config[:curve_segment_count] = 22
        config[:arc_segment_count] = 22
        config[:null] = @ogl.null

        vbuf = NK_BUFFER.new
        ebuf = NK_BUFFER.new
        nk_buffer_init_fixed(vbuf, vertices, max_vertex_buffer)
        nk_buffer_init_fixed(ebuf, elements, max_element_buffer)
        nk_convert(@ctx, @ogl.cmds, vbuf, ebuf, config)
      end
      glUnmapBuffer(GL_ARRAY_BUFFER)
      glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER)
      # offset = nk_buffer_memory_const(ebuf) # GL2
      offset = FFI::Pointer::NULL # GL3
      nk_draw_foreach(@ctx, @ogl.cmds) do |cmd_ptr|
        cmd = NK_DRAW_COMMAND.new(cmd_ptr)
        next if cmd[:elem_count] == 0
        glBindTexture(GL_TEXTURE_2D, cmd[:texture][:id])
        glScissor(
          (cmd[:clip_rect][:x] * @fb_scale[:x]).to_i,
          (($nkglfw.display_height - (cmd[:clip_rect][:y] + cmd[:clip_rect][:h])).to_i * @fb_scale[:y]).to_i,
          (cmd[:clip_rect][:w] * @fb_scale[:x]).to_i,
          (cmd[:clip_rect][:h] * @fb_scale[:y])).to_i
        glDrawElements(GL_TRIANGLES, cmd[:elem_count], GL_UNSIGNED_SHORT, offset)
        offset += (FFI.type_size(:ushort) * cmd[:elem_count]) # NOTE : FFI.type_size(:ushort) == size of :nk_draw_index
      end
      nk_clear(ctx)
      # nk_buffer_free(vbuf)
      # nk_buffer_free(ebuf)
    end

    glUseProgram(0)
    glBindBuffer(GL_ARRAY_BUFFER, 0)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
    glBindVertexArray(0)
    glDisable(GL_BLEND)
    glDisable(GL_SCISSOR_TEST)
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
