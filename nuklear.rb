require 'ffi'

module Nuklear
  extend FFI::Library

  NK_UTF_INVALID       = 0xFFFD
  NK_UTF_SIZE          = 4
  NK_INPUT_MAX         = 16
  NK_MAX_NUMBER_BUFFER = 64
  NK_SCROLLBAR_HIDING_TIMEOUT = 4.0

  typedef :int16,      :nk_short
  typedef :uint16,     :nk_ushort
  typedef :int32,      :nk_int
  typedef :uint32,     :nk_uint
  typedef :nk_uint,    :nk_hash
  typedef :uintptr_t,  :nk_size
  typedef :uintptr_t,  :nk_ptr
  typedef :uint32,     :nk_flags
  typedef :nk_uint,    :nk_rune
  typedef :uint8,      :nk_byte

  NK_FALSE = 0
  NK_TRUE  = 1

  class NK_COLOR < FFI::Struct
    layout :r, :nk_byte,
           :g, :nk_byte,
           :b, :nk_byte,
           :a, :nk_byte
  end

  class NK_COLORF < FFI::Struct
    layout :r, :float,
           :g, :float,
           :b, :float,
           :a, :float
  end

  class NK_VEC2 < FFI::Struct
    layout :x, :float,
           :y, :float

  end

  class NK_VEC2I < FFI::Struct
    layout :x, :short,
           :y, :short
  end

  class NK_RECT < FFI::Struct
    layout :x, :float,
           :y, :float,
           :w, :float,
           :h, :float
  end

  class NK_RECTI < FFI::Struct
    layout :x, :short,
           :y, :short,
           :w, :short,
           :h, :short
  end

  class NK_GLYPH < FFI::Struct
    layout :val, [:char, 8]

    def [](index) # Note : Added for Ruby
      val[index]
    end
  end

  class NK_HANDLE < FFI::Union
    layout :ptr, :pointer,
           :id, :int
  end

  class NK_IMAGE < FFI::Struct
    layout :handle, NK_HANDLE,
           :w, :ushort,
           :h, :ushort,
           :region, [:ushort, 4]
  end

  class NK_CURSOR < FFI::Struct
    layout :img, NK_IMAGE,
           :size, NK_VEC2,
           :size, NK_VEC2
  end

  class NK_SCROLL < FFI::Struct
    layout :x, :ushort,
           :y, :ushort
  end

  NK_HEADING = enum :nk_up, :nk_right, :nk_down, :nk_left
  NK_BUTTON_BEHAVIOR = enum :NK_BUTTON_DEFAULT, :NK_BUTTON_REPEATER
  NK_MODIFY          = enum :NK_FIXED, NK_FALSE, :NK_MODIFIABLE, NK_TRUE
  NK_ORIENTATION     = enum :NK_VERTICAL, :NK_HORIZONTAL
  NK_COLLAPSE_STATES = enum :NK_MINIMIZED, NK_FALSE, :NK_MAXIMIZED, NK_TRUE
  NK_SHOW_STATES     = enum :NK_HIDDEN, 0, :NK_SHOWN, 1
  NK_CHART_TYPE      = enum :NK_CHART_LINES, :NK_CHART_COLUMN, :NK_CHART_MAX
  NK_CHART_EVENT     = enum :NK_CHART_HOVERING, 0x01, :NK_CHART_CLICKED, 0x02
  NK_COLOR_FORMAT    = enum :NK_RGB, :NK_RGBA
  NK_POPUP_TYPE      = enum :NK_POPUP_STATIC, :NK_POPUP_DYNAMIC
  NK_LAYOUT_FORMAT   = enum :NK_DYNAMIC, :NK_STATIC
  NK_TREE_TYPE       = enum :NK_TREE_NODE, :NK_TREE_TAB
  NK_ANTI_ALIASING   = enum :NK_ANTI_ALIASING_OFF, :NK_ANTI_ALIASING_ON

  callback :nk_plugin_alloc,  [NK_HANDLE, :pointer, :nk_size], :pointer
  callback :nk_plugin_free,   [NK_HANDLE, :pointer], :void
  callback :nk_plugin_filter, [:pointer, :nk_rune], :int32
  callback :nk_plugin_paste,  [NK_HANDLE, :pointer], :void
  callback :nk_plugin_copy,   [NK_HANDLE, :pointer, :int32], :void


  class NK_ALLOCATOR < FFI::Struct
    layout :userdata, NK_HANDLE,
           :alloc, :nk_plugin_alloc,
           :free, :nk_plugin_free
  end

  class NK_DRAW_NULL_TEXTURE < FFI::Struct
    layout :texture, NK_HANDLE,
           :uv, NK_VEC2
  end

  class NK_CONVERT_CONFIG < FFI::Struct
    layout :global_alpha, :float,
           :line_AA, NK_ANTI_ALIASING,
           :shape_AA, NK_ANTI_ALIASING,
           :circle_segment_count, :uint32,
           :arc_segment_count, :uint32,
           :curve_segment_count, :uint32,
           :null, NK_DRAW_NULL_TEXTURE,
           :vertex_layout, :pointer, # NK_DRAW_VERTEX_LAYOUT_ELEMENT.ptr,
           :vertex_size, :nk_size,
           :vertex_alignment, :nk_size
  end

  NK_SYMBOL_TYPE = enum :NK_SYMBOL_NONE,
                        :NK_SYMBOL_X,
                        :NK_SYMBOL_UNDERSCORE,
                        :NK_SYMBOL_CIRCLE_SOLID,
                        :NK_SYMBOL_CIRCLE_OUTLINE,
                        :NK_SYMBOL_RECT_SOLID,
                        :NK_SYMBOL_RECT_OUTLINE,
                        :NK_SYMBOL_TRIANGLE_UP,
                        :NK_SYMBOL_TRIANGLE_DOWN,
                        :NK_SYMBOL_TRIANGLE_LEFT,
                        :NK_SYMBOL_TRIANGLE_RIGHT,
                        :NK_SYMBOL_PLUS,
                        :NK_SYMBOL_MINUS,
                        :NK_SYMBOL_MAX

  NK_KEYS = enum :NK_KEY_NONE,
                 :NK_KEY_SHIFT,
                 :NK_KEY_CTRL,
                 :NK_KEY_DEL,
                 :NK_KEY_ENTER,
                 :NK_KEY_TAB,
                 :NK_KEY_BACKSPACE,
                 :NK_KEY_COPY,
                 :NK_KEY_CUT,
                 :NK_KEY_PASTE,
                 :NK_KEY_UP,
                 :NK_KEY_DOWN,
                 :NK_KEY_LEFT,
                 :NK_KEY_RIGHT,
                 #
                 :NK_KEY_TEXT_INSERT_MODE,
                 :NK_KEY_TEXT_REPLACE_MODE,
                 :NK_KEY_TEXT_RESET_MODE,
                 :NK_KEY_TEXT_LINE_START,
                 :NK_KEY_TEXT_LINE_END,
                 :NK_KEY_TEXT_START,
                 :NK_KEY_TEXT_END,
                 :NK_KEY_TEXT_UNDO,
                 :NK_KEY_TEXT_REDO,
                 :NK_KEY_TEXT_WORD_LEFT,
                 :NK_KEY_TEXT_WORD_RIGHT,
                 #
                 :NK_KEY_SCROLL_START,
                 :NK_KEY_SCROLL_END,
                 :NK_KEY_SCROLL_DOWN,
                 :NK_KEY_SCROLL_UP,
                 #
                 :NK_KEY_MAX

  NK_BUTTONS = enum :NK_BUTTON_LEFT,
                    :NK_BUTTON_MIDDLE,
                    :NK_BUTTON_RIGHT,
                    :NK_BUTTON_MAX

  NK_STYLE_COLORS = enum :NK_COLOR_TEXT,
                         :NK_COLOR_WINDOW,
                         :NK_COLOR_HEADER,
                         :NK_COLOR_BORDER,
                         :NK_COLOR_BUTTON,
                         :NK_COLOR_BUTTON_HOVER,
                         :NK_COLOR_BUTTON_ACTIVE,
                         :NK_COLOR_TOGGLE,
                         :NK_COLOR_TOGGLE_HOVER,
                         :NK_COLOR_TOGGLE_CURSOR,
                         :NK_COLOR_SELECT,
                         :NK_COLOR_SELECT_ACTIVE,
                         :NK_COLOR_SLIDER,
                         :NK_COLOR_SLIDER_CURSOR,
                         :NK_COLOR_SLIDER_CURSOR_HOVER,
                         :NK_COLOR_SLIDER_CURSOR_ACTIVE,
                         :NK_COLOR_PROPERTY,
                         :NK_COLOR_EDIT,
                         :NK_COLOR_EDIT_CURSOR,
                         :NK_COLOR_COMBO,
                         :NK_COLOR_CHART,
                         :NK_COLOR_CHART_COLOR,
                         :NK_COLOR_CHART_COLOR_HIGHLIGHT,
                         :NK_COLOR_SCROLLBAR,
                         :NK_COLOR_SCROLLBAR_CURSOR,
                         :NK_COLOR_SCROLLBAR_CURSOR_HOVER,
                         :NK_COLOR_SCROLLBAR_CURSOR_ACTIVE,
                         :NK_COLOR_TAB_HEADER,
                         :NK_COLOR_COUNT

  NK_STYLE_CURSOR = enum :NK_CURSOR_ARROW,
                         :NK_CURSOR_TEXT,
                         :NK_CURSOR_MOVE,
                         :NK_CURSOR_RESIZE_VERTICAL,
                         :NK_CURSOR_RESIZE_HORIZONTAL,
                         :NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT,
                         :NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT,
                         :NK_CURSOR_COUNT

  NK_WIDGET_LAYOUT_STATES = enum :NK_WIDGET_INVALID,
                                 :NK_WIDGET_VALID,
                                 :NK_WIDGET_ROM

  NK_WIDGET_STATES = enum :NK_WIDGET_STATE_MODIFIED, (1 << 1),
                          :NK_WIDGET_STATE_INACTIVE, (1 << 2),
                          :NK_WIDGET_STATE_ENTERED,  (1 << 3),
                          :NK_WIDGET_STATE_HOVER,    (1 << 4),
                          :NK_WIDGET_STATE_ACTIVED,  (1 << 5),
                          :NK_WIDGET_STATE_LEFT,     (1 << 6),
                          :NK_WIDGET_STATE_HOVERED,  ((1 << 4)|(1 << 1)), # (NK_WIDGET_STATE_HOVER|NK_WIDGET_STATE_MODIFIED),
                          :NK_WIDGET_STATE_ACTIVE,   ((1 << 5)|(1 << 1))  # (:NK_WIDGET_STATE_ACTIVED|:NK_WIDGET_STATE_MODIFIED)

  NK_TEXT_ALIGN = enum :NK_TEXT_ALIGN_LEFT, 0x01,
                       :NK_TEXT_ALIGN_CENTERED, 0x02,
                       :NK_TEXT_ALIGN_RIGHT, 0x04,
                       :NK_TEXT_ALIGN_TOP, 0x08,
                       :NK_TEXT_ALIGN_MIDDLE, 0x10,
                       :NK_TEXT_ALIGN_BOTTOM, 0x20

  NK_TEXT_ALIGNMENT = enum :NK_TEXT_LEFT,     0x10|0x01, # :NK_TEXT_ALIGN_MIDDLE|:NK_TEXT_ALIGN_LEFT,
                           :NK_TEXT_CENTERED, 0x10|0x02, # :NK_TEXT_ALIGN_MIDDLE|:NK_TEXT_ALIGN_CENTERED,
                           :NK_TEXT_RIGHT,    0x10|0x04  # :NK_TEXT_ALIGN_MIDDLE|:NK_TEXT_ALIGN_RIGHT

  NK_EDIT_FLAGS = enum :NK_EDIT_DEFAULT, 0,
                       :NK_EDIT_READ_ONLY, (1 << 0),
                       :NK_EDIT_AUTO_SELECT, (1 << 1),
                       :NK_EDIT_SIG_ENTER, (1 << 2),
                       :NK_EDIT_ALLOW_TAB, (1 << 3),
                       :NK_EDIT_NO_CURSOR, (1 << 4),
                       :NK_EDIT_SELECTABLE, (1 << 5),
                       :NK_EDIT_CLIPBOARD, (1 << 6),
                       :NK_EDIT_CTRL_ENTER_NEWLINE, (1 << 7),
                       :NK_EDIT_NO_HORIZONTAL_SCROLL, (1 << 8),
                       :NK_EDIT_ALWAYS_INSERT_MODE, (1 << 9),
                       :NK_EDIT_MULTILINE, (1 << 11),
                       :NK_EDIT_GOTO_END_ON_ACTIVATE, (1 << 12)

  NK_EDIT_TYPES = enum :NK_EDIT_SIMPLE,  (1 << 9),                                      # :NK_EDIT_ALWAYS_INSERT_MODE,
                       :NK_EDIT_FIELD,   (1 << 9)|(1 << 5)|(1 << 6),                    # :NK_EDIT_SIMPLE|:NK_EDIT_SELECTABLE|:NK_EDIT_CLIPBOARD,
                       :NK_EDIT_BOX,     (1 << 9)|(1 << 5)|(1 << 11)|(1 << 3)|(1 << 6), # :NK_EDIT_ALWAYS_INSERT_MODE| :NK_EDIT_SELECTABLE|:NK_EDIT_MULTILINE|:NK_EDIT_ALLOW_TAB|:NK_EDIT_CLIPBOARD,
                       :NK_EDIT_EDITOR,  (1 << 5)|(1 << 11)|(1 << 3)|(1 << 6)           # :NK_EDIT_SELECTABLE|:NK_EDIT_MULTILINE|:NK_EDIT_ALLOW_TAB|:NK_EDIT_CLIPBOARD

  NK_EDIT_EVENTS = enum :NK_EDIT_ACTIVE, (1 << 0),
                        :NK_EDIT_INACTIVE, (1 << 1),
                        :NK_EDIT_ACTIVATED, (1 << 2),
                        :NK_EDIT_DEACTIVATED, (1 << 3),
                        :NK_EDIT_COMMITED, (1 << 4)

  NK_PANEL_FLAGS = enum :NK_WINDOW_BORDER,            (1 << 0),
                        :NK_WINDOW_MOVABLE,           (1 << 1),
                        :NK_WINDOW_SCALABLE,          (1 << 2),
                        :NK_WINDOW_CLOSABLE,          (1 << 3),
                        :NK_WINDOW_MINIMIZABLE,       (1 << 4),
                        :NK_WINDOW_NO_SCROLLBAR,      (1 << 5),
                        :NK_WINDOW_TITLE,             (1 << 6),
                        :NK_WINDOW_SCROLL_AUTO_HIDE,  (1 << 7),
                        :NK_WINDOW_BACKGROUND,        (1 << 8)

  # Layout: Tree

  def nk_tree_push(ctx, type, title, state)
    lineno = caller[0].split(':')[1].to_i
    nk_tree_push_hashed(ctx, type, title, state, caller[0], caller[0].length, lineno)
  end

  def nk_tree_push_id(ctx, type, title, state, id)
    nk_tree_push_hashed(ctx, type, title, state, caller[0], caller[0].length, id)
  end

  def nk_tree_image_push(ctx, type, img, title, state)
    lineno = caller[0].split(':')[1].to_i
    nk_tree_image_push_hashed(ctx, type, img, title, state, caller[0], caller[0].length, lineno)
  end

  def nk_tree_image_push_id(ctx, type, img, title, state, id)
    nk_tree_image_push_hashed(ctx, type, img, title, state, caller[0], caller[0].length, id)
  end

  # Chart

  callback :nk_value_getter_f, [:pointer, :int32], :float # Added for Ruby

  # Combobox

  callback :nk_item_getter_f, [:pointer, :int32, :pointer], :void # Added for Ruby

  # Drawing

  def nk_foreach(ctx, &blk)
    cmd = nk__begin(ctx)
    while cmd.null? == false
      blk.call(ctx, cmd)
      cmd = nk__next(ctx, cmd)
    end
  end

  def nk_draw_foreach(ctx, buf, &blk)
    cmd = nk__draw_begin(ctx, buf)
    while cmd.null? == false
      blk.call(cmd)
      cmd = nk__draw_next(cmd, buf, ctx)
    end
  end

  def nk_draw_foreach_bounded(ctx, from, to, &blk)
    cmd = from
    while cmd.null? == false && cmd.address >= to.address
      blk.call(cmd)
      cmd = cmd.slice(-NK_BUFFER.size, NK_BUFFER.size) # --(cmd)
    end
  end


  #
  # MEMORY BUFFER
  #

  class NK_MEMORY_STATUS < FFI::Struct
    layout :memory, :pointer,
           :type, :uint32,
           :size, :nk_size,
           :allocated, :nk_size,
           :needed, :nk_size,
           :calls, :nk_size
  end

  NK_ALLOCATION_TYPE = enum :NK_BUFFER_FIXED,
                            :NK_BUFFER_DYNAMIC

  NK_BUFFER_ALLOCATION_TYPE = enum :NK_BUFFER_FRONT,
                                   :NK_BUFFER_BACK,
                                   :NK_BUFFER_MAX

  class NK_BUFFER_MARKER < FFI::Struct
    layout :active, :int32,
           :offset, :nk_size
  end

  class NK_MEMORY < FFI::Struct
    layout :ptr, :pointer,
           :size, :nk_size
  end

  class NK_BUFFER < FFI::Struct
    layout :marker, [NK_BUFFER_MARKER, NK_BUFFER_ALLOCATION_TYPE[:NK_BUFFER_MAX]],
           :pool, NK_ALLOCATOR,
           :type, NK_ALLOCATION_TYPE,
           :memory, NK_MEMORY,
           :grow_factor, :float,
           :allocated, :nk_size,
           :needed, :nk_size,
           :calls, :nk_size,
           :size, :nk_size
  end

  #
  # STRING
  #

  class NK_STR < FFI::Struct
    layout :buffer, NK_BUFFER,
           :len, :int32
  end

  #
  # TEXT EDITOR
  #

  NK_TEXTEDIT_UNDOSTATECOUNT = 99
  NK_TEXTEDIT_UNDOCHARCOUNT  = 999

  class NK_CLIPBOARD < FFI::Struct
    layout :userdata, NK_HANDLE,
           :paste, :nk_plugin_paste,
           :copy, :nk_plugin_copy
  end

  class NK_TEXT_UNDO_RECORD < FFI::Struct
    layout :where, :int32,
           :insert_length, :short,
           :delete_length, :short,
           :char_storage, :short
  end

  class NK_TEXT_UNDO_STATE < FFI::Struct
    layout :undo_rec, [NK_TEXT_UNDO_RECORD, NK_TEXTEDIT_UNDOSTATECOUNT],
           :undo_char, [:nk_rune, NK_TEXTEDIT_UNDOCHARCOUNT],
           :undo_point, :short,
           :redo_point, :short,
           :undo_char_point, :short,
           :redo_char_point, :short
  end

  NK_TEXT_EDIT_TYPE = enum :NK_TEXT_EDIT_SINGLE_LINE,
                           :NK_TEXT_EDIT_MULTI_LINE

  NK_TEXT_EDIT_MODE = enum :NK_TEXT_EDIT_MODE_VIEW,
                           :NK_TEXT_EDIT_MODE_INSERT,
                           :NK_TEXT_EDIT_MODE_REPLACE

  class NK_TEXT_EDIT < FFI::Struct
    layout :clip, NK_CLIPBOARD,
           :string, NK_STR,
           :filter, :nk_plugin_filter,
           :scrollbar, NK_VEC2,

           :cursor, :int32,
           :select_start, :int32,
           :select_end, :int32,
           :mode, :uint8,
           :cursor_at_end_of_line, :uint8,
           :initialized, :uint8,
           :has_preferred_x, :uint8,
           :single_line, :uint8,
           :active, :uint8,
           :padding1, :uint8,
           :preferred_x, :float,
           :undo, NK_TEXT_UNDO_STATE
  end


  #
  # FONT
  #

  callback :nk_text_width_f, [NK_HANDLE.by_value, :float, :pointer, :int32], :float
  callback :nk_query_font_glyph_f, [NK_HANDLE.by_value, :float, :pointer, :nk_rune, :nk_rune], :float

  class NK_USER_FONT_GLYPH < FFI::Struct
    layout :uv, [NK_VEC2, 2],
           :offset, NK_VEC2,
           :width, :float,
           :height, :float,
           :xadvance, :float
  end

  class NK_USER_FONT < FFI::Struct
    layout :userdata, NK_HANDLE,
           :height, :float,
           :width, :nk_text_width_f,
           # :width, callback([NK_HANDLE, :float, :pointer, :int32], :float),
           :query, :nk_query_font_glyph_f, # NOTE : available only if NK_INCLUDE_VERTEX_BUFFER_OUTPUT is defined.
           :texture, NK_HANDLE             # NOTE : available only if NK_INCLUDE_VERTEX_BUFFER_OUTPUT is defined.

  end

  # /// NOTE : The section below is available only if NK_INCLUDE_FONT_BAKING is defined. \\\

  NK_FONT_COORD_TYPE = enum :NK_COORD_UV,
                            :NK_COORD_PIXEL

  class NK_BAKED_FONT < FFI::Struct
    layout :height, :float,
           :ascent, :float,
           :descent, :float,
           :glyph_offset, :nk_rune,
           :glyph_count, :nk_rune,
           :ranges, :pointer # const nk_rune *ranges;
  end

  class NK_FONT_CONFIG < FFI::Struct
    layout :next, NK_FONT_CONFIG.ptr, # struct nk_font_config *next;
=begin
           :next, :pointer, # struct nk_font_config *next;
=end
           :ttf_blob, :pointer,
           :ttf_size, :nk_size,
           :ttf_data_owned_by_atlas, :uint8,
           :merge_mode, :uint8,
           :pixel_snap, :uint8,
           :oversample_v, :uint8,
           :oversample_h, :uint8,
           :padding, [:uint8, 3],
           :size, :float,
           :coord_type, NK_FONT_COORD_TYPE,
           :sapcing, NK_VEC2,
           :range, :pointer, # const nk_rune *range;
#           :font, :pointer,  # struct nk_baked_font *font;
           :font, NK_BAKED_FONT.ptr,  # struct nk_baked_font *font;
           :fallback_glyph, :nk_rune
  end

  class NK_FONT_GLYPH < FFI::Struct
    layout :codepoint, :nk_rune,
           :xadvance, :float,
           :x0, :float,
           :y0, :float,
           :x1, :float,
           :y1, :float,
           :w, :float,
           :h, :float,
           :u0, :float,
           :v0, :float,
           :u1, :float,
           :v1, :float
  end

  class NK_FONT < FFI::Struct
    layout :next, NK_FONT.ptr,
=begin
           :next, :pointer, # nk_font *next;
=end
           :handle, NK_USER_FONT,
           :info, NK_BAKED_FONT,
           :scale, :float,
           :glyphs, NK_FONT_GLYPH.ptr,   # struct nk_font_glyph *glyphs;
           :fallback, NK_FONT_GLYPH.ptr, # const struct nk_font_glyph *fallback;
=begin
           :glyphs, :pointer,   # struct nk_font_glyph *glyphs;
           :fallback, :pointer, # const struct nk_font_glyph *fallback;
=end
           :fallback_codepoint, :nk_rune,
           :texture, NK_HANDLE,
           :config, NK_FONT_CONFIG.ptr # struct nk_font_config *config;
=begin
           :config, :pointer # struct nk_font_config *config;
=end
  end

  NK_FONT_ATLAS_FORMAT = enum :NK_FONT_ATLAS_ALPHA8,
                              :NK_FONT_ATLAS_RGBA32

  class NK_FONT_ATLAS < FFI::Struct
    layout :pixel, :pointer,
           :tex_width, :int32,
           :tex_height, :int32,
           :permanent, NK_ALLOCATOR,
           :temporary, NK_ALLOCATOR,
           :custom, NK_RECTI,
           :cursors, [NK_CURSOR, NK_STYLE_CURSOR[:NK_CURSOR_COUNT]],

           :glyph_count, :int32,
           :glyphs, NK_FONT_GLYPH.ptr,  # struct nk_font_glyph *glyphs;
           :default_font, NK_FONT.ptr,  # struct nk_font *default_font;
           :fonts, NK_FONT.ptr,            # struct nk_font *fonts;
           :config, NK_FONT_CONFIG.ptr, # struct nk_font_config *config;
=begin
           :glyphs, :pointer,       # struct nk_font_glyph *glyphs;
           :default_font, :pointer, # struct nk_font *default_font;
           :fonts, :pointer,        # struct nk_font *fonts;
           :config, :pointer,       # struct nk_font_config *config;
=end
           :font_num, :int32
  end

  # \\\ NOTE : The section above is available only if NK_INCLUDE_FONT_BAKING is defined. ///

  #
  # DRAWING
  #

  NK_COMMAND_TYPE = enum :NK_COMMAND_NOP,
                         :NK_COMMAND_SCISSOR,
                         :NK_COMMAND_LINE,
                         :NK_COMMAND_CURVE,
                         :NK_COMMAND_RECT,
                         :NK_COMMAND_RECT_FILLED,
                         :NK_COMMAND_RECT_MULTI_COLOR,
                         :NK_COMMAND_CIRCLE,
                         :NK_COMMAND_CIRCLE_FILLED,
                         :NK_COMMAND_ARC,
                         :NK_COMMAND_ARC_FILLED,
                         :NK_COMMAND_TRIANGLE,
                         :NK_COMMAND_TRIANGLE_FILLED,
                         :NK_COMMAND_POLYGON,
                         :NK_COMMAND_POLYGON_FILLED,
                         :NK_COMMAND_POLYLINE,
                         :NK_COMMAND_TEXT,
                         :NK_COMMAND_IMAGE


  class NK_COMMAND < FFI::Struct
    layout :type, NK_COMMAND_TYPE,
           :next, :nk_size,
           :userdata, NK_HANDLE # NOTE : available only if NK_INCLUDE_COMMAND_USERDATA is defined.
  end

  class NK_COMMAND_SCISSOR < FFI::Struct
    layout :header, NK_COMMAND,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort
  end

  class NK_COMMAND_LINE < FFI::Struct
    layout :header, NK_COMMAND,
           :line_thickness, :ushort,
           :begin, NK_VEC2I,
           :end, NK_VEC2I,
           :color, NK_COLOR
  end

  class NK_COMMAND_CURVE < FFI::Struct
    layout :header, NK_COMMAND,
           :line_thickness, :ushort,
           :begin, NK_VEC2I,
           :end, NK_VEC2I,
           :ctrl, [NK_VEC2I, 2],
           :color, NK_COLOR
  end

  class NK_COMMAND_RECT < FFI::Struct
    layout :header, NK_COMMAND,
           :rounding, :ushort,
           :line_thickness, :ushort,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :color, NK_COLOR
  end

  class NK_COMMAND_RECT_FILLED < FFI::Struct
    layout :header, NK_COMMAND,
           :rounding, :ushort,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :color, NK_COLOR
  end

  class NK_COMMAND_RECT_MULTI_COLOR < FFI::Struct
    layout :header, NK_COMMAND,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :left, NK_COLOR,
           :top, NK_COLOR,
           :bottom, NK_COLOR,
           :right, NK_COLOR
  end

  class NK_COMMAND_TRIANGLE < FFI::Struct
    layout :header, NK_COMMAND,
           :line_thickness, :ushort,
           :a, NK_VEC2I,
           :b, NK_VEC2I,
           :c, NK_VEC2I,
           :color, NK_COLOR
  end

  class NK_COMMAND_TRIANGLE_FILLED < FFI::Struct
    layout :header, NK_COMMAND,
           :a, NK_VEC2I,
           :b, NK_VEC2I,
           :c, NK_VEC2I,
           :color, NK_COLOR
  end

  class NK_COMMAND_CIRCLE < FFI::Struct
    layout :header, NK_COMMAND,
           :x, :short,
           :y, :short,
           :line_thickness, :ushort,
           :w, :ushort,
           :h, :ushort,
           :color, NK_COLOR
  end

  class NK_COMMAND_CIRCLE_FILLED < FFI::Struct
    layout :header, NK_COMMAND,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :color, NK_COLOR
  end

  class NK_COMMAND_ARC < FFI::Struct
    layout :header, NK_COMMAND,
           :cx, :short,
           :cy, :short,
           :r, :ushort,
           :line_thickness, :ushort,
           :a, [:float, 2],
           :color, NK_COLOR
  end

  class NK_COMMAND_ARC_FILLED < FFI::Struct
    layout :header, NK_COMMAND,
           :cx, :short,
           :cy, :short,
           :r, :ushort,
           :a, [:float, 2],
           :color, NK_COLOR
  end

  class NK_COMMAND_POLYGON < FFI::Struct
    layout :header, NK_COMMAND,
           :color, NK_COLOR,
           :line_thickness, :ushort,
           :point_count, :ushort,
           :points, :pointer # NOTE : Originally defined here is 'struct nk_vec2i points[1];'.
  end

  class NK_COMMAND_POLYGON_FILLED < FFI::Struct
    layout :header, NK_COMMAND,
           :color, NK_COLOR,
           :point_count, :ushort,
           :points, :pointer # NOTE : Originally defined here is 'struct nk_vec2i points[1];'.
  end

  class NK_COMMAND_POLYLINE < FFI::Struct
    layout :header, NK_COMMAND,
           :color, NK_COLOR,
           :line_thickness, :ushort,
           :point_count, :ushort,
           :points, :pointer # NOTE : Originally defined here is 'struct nk_vec2i points[1];'.
  end

  class NK_COMMAND_IMAGE < FFI::Struct
    layout :header, NK_COMMAND,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :img, NK_IMAGE,
           :col, NK_COLOR
  end

  class NK_COMMAND_TEXT < FFI::Struct
    layout :header, NK_COMMAND,
           :font, :pointer, # const struct nk_user_font *font;
           :background, NK_COLOR,
           :foreground, NK_COLOR,
           :x, :short,
           :y, :short,
           :w, :ushort,
           :h, :ushort,
           :height, :float,
           :length, :int32,
           :strng, :pointer # NOTE : Originally defined here is 'char string[1];'.
  end

  NK_COMMAND_CLIPPING = enum :NK_CLIPPING_OFF, NK_FALSE,
                             :NK_CLIPPING_ON, NK_TRUE


  class NK_COMMAND_BUFFER < FFI::Struct
    layout :base, :pointer, # struct nk_buffer *base;
    :clip, NK_RECT, 
    :use_clipping, :int32,
    :userdata, NK_HANDLE,
    :begin, :nk_size,
    :end, :nk_size,
    :last, :nk_size
  end

  #
  # INPUT
  #

  class NK_MOUSE_BUTTON < FFI::Struct
    layout :down, :int32,
           :clicked, :uint32,
           :clicked_pos, NK_VEC2
  end

  class NK_MOUSE < FFI::Struct
    layout :buttons, [NK_MOUSE_BUTTON, NK_BUTTONS[:NK_BUTTON_MAX]],
           :pos, NK_VEC2,
           :prev, NK_VEC2,
           :delta, NK_VEC2,
           :scroll_delta, :float,
           :grab, :uint8,
           :grabbed, :uint8,
           :ungrab, :uint8
  end

  class NK_KEY < FFI::Struct
    layout :down, :int32,
           :clicked, :uint32
  end

  class NK_KEYBOARD < FFI::Struct
    layout :keys, [NK_KEY, NK_KEYS[:NK_KEY_MAX]],
           :text, [:int8, NK_INPUT_MAX],
           :text_en, :int32
  end

  class NK_INPUT < FFI::Struct
    layout :keyboard, NK_KEYBOARD,
           :mouse, NK_MOUSE
  end

  #
  # DRAW LIST
  #

  # /// NOTE : The section below is available only if NK_INCLUDE_VERTEX_BUFFER_OUTPUT is defined. \\\

  typedef :ushort, :nk_draw_index
  typedef :nk_uint, :nk_draw_vertex_color

  NK_DRAW_LIST_STROKE = enum :NK_STROKE_OPEN, NK_FALSE,
                             :NK_STROKE_CLOSED, NK_TRUE

  NK_DRAW_VERTEX_LAYOUT_ATTRIBUTE = enum :NK_VERTEX_POSITION,
                                         :NK_VERTEX_COLOR,
                                         :NK_VERTEX_TEXCOORD,
                                         :NK_VERTEX_ATTRIBUTE_COUNT

  NK_DRAW_VERTEX_LAYOUT_FORMAT = enum :NK_FORMAT_SCHAR,   0,
                                      :NK_FORMAT_SSHORT,  1,
                                      :NK_FORMAT_SINT,    2,
                                      :NK_FORMAT_UCHAR,   3,
                                      :NK_FORMAT_USHORT,  4,
                                      :NK_FORMAT_UINT,    5,
                                      :NK_FORMAT_FLOAT,   6,
                                      :NK_FORMAT_DOUBLE,  7,
                                      :NK_FORMAT_COLOR_BEGIN,  8,
                                      :NK_FORMAT_R8G8B8,       8, # == :NK_FORMAT_COLOR_BEGIN,
                                      :NK_FORMAT_R16G15B16,    9,
                                      :NK_FORMAT_R32G32B32,    10,
                                      :NK_FORMAT_R8G8B8A8,             11,
                                      :NK_FORMAT_R16G15B16A16,         12,
                                      :NK_FORMAT_R32G32B32A32,         13,
                                      :NK_FORMAT_R32G32B32A32_FLOAT,   14,
                                      :NK_FORMAT_R32G32B32A32_DOUBLE,  15,
                                      :NK_FORMAT_RGB32,      16,
                                      :NK_FORMAT_RGBA32,     17,
                                      :NK_FORMAT_COLOR_END,  17, # == :NK_FORMAT_RGBA32,
                                      :NK_FORMAT_COUNT,      18

  class NK_DRAW_VERTEX_LAYOUT_ELEMENT < FFI::Struct
    layout :attribute, NK_DRAW_VERTEX_LAYOUT_ATTRIBUTE,
           :format, NK_DRAW_VERTEX_LAYOUT_FORMAT,
           :offset, :nk_size

    def self.get_layout(attr, fmt, ofs)
      lyt = NK_DRAW_VERTEX_LAYOUT_ELEMENT.new
      lyt[:attribute] = attr
      lyt[:format]    = fmt
      lyt[:offset]    = ofs
      return lyt
    end

    def self.end_layout # == NK_VERTEX_LAYOUT_END
      return self.get_layout(NK_DRAW_VERTEX_LAYOUT_ATTRIBUTE[:NK_VERTEX_ATTRIBUTE_COUNT], NK_DRAW_VERTEX_LAYOUT_FORMAT[:NK_FORMAT_COUNT], 0)
    end
  end

  class NK_DRAW_COMMAND < FFI::Struct
    layout :elem_count, :uint32,
           :clip_rect, NK_RECT,
           :texture, NK_HANDLE
  end

  class NK_DRAW_LIST < FFI::Struct
    layout :config, NK_CONVERT_CONFIG,
           :clip_rect, NK_RECT,
           :buffer, :pointer, # NK_BUFFER
           :vertices, :pointer, # NK_BUFFER
           :elements, :pointer, # NK_BUFFER
           :element_count, :uint32,
           :vertex_count, :uint32,
           :cmd_offset, :nk_size,
           :cmd_count, :uint32,
           :path_count, :uint32,
           :path_offset, :uint32,
           :circle_vtx, [NK_VEC2, 12]
  end

  # \\\ NOTE : The section above is available only if NK_INCLUDE_VERTEX_BUFFER_OUTPUT is defined. ///

  #
  # GUI
  #

  NK_STYLE_ITEM_TYPE = enum :NK_STYLE_ITEM_COLOR,
                            :NK_STYLE_ITEM_IMAGE

  class NK_STYLE_ITEM_DATA < FFI::Union
    layout :image, NK_IMAGE,
           :color, NK_COLOR
  end

  class NK_STYLE_ITEM < FFI::Struct
    layout :type, NK_STYLE_ITEM_TYPE,
           :data, NK_STYLE_ITEM_DATA
  end

  class NK_STYLE_TEXT < FFI::Struct
    layout :color, NK_COLOR,
           :padding, NK_VEC2
  end

  callback :nk_draw_begin_f, [:pointer, NK_HANDLE], :void # Added for Ruby
  callback :nk_draw_end_f, [:pointer, NK_HANDLE], :void   # Added for Ruby

  class NK_STYLE_BUTTON < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :text_background, NK_COLOR,
           :text_normal, NK_COLOR,
           :text_hover, NK_COLOR,
           :text_active, NK_COLOR,
           :text_alignment, :nk_flags,
           #
           :border, :float,
           :rounding, :float,
           :padding, NK_VEC2,
           :image_padding, NK_VEC2,
           :touch_padding, NK_VEC2,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_TOGGLE < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :cursor_normal, NK_STYLE_ITEM,
           :cursor_hover, NK_STYLE_ITEM,
           #
           :text_normal, NK_COLOR,
           :text_hover, NK_COLOR,
           :text_active, NK_COLOR,
           :text_background, NK_COLOR,
           :text_alignment, :nk_flags,
           #
           :padding, NK_VEC2,
           :touch_padding, NK_VEC2,
           :spacing, :float,
           :border, :float,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_SELECTABLE < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :pressed, NK_STYLE_ITEM,
           #
           :normal_active, NK_STYLE_ITEM,
           :hover_active, NK_STYLE_ITEM,
           :pressed_active, NK_STYLE_ITEM,
           #
           :text_normal, NK_COLOR,
           :text_hover, NK_COLOR,
           :text_pressed, NK_COLOR,
           #
           :text_normal_active, NK_COLOR,
           :text_hover_active, NK_COLOR,
           :text_pressed_active, NK_COLOR,
           :text_background, NK_COLOR,
           :text_alignment, :nk_flags,
           #
           :rounding, :float,
           :padding, NK_VEC2,
           :touch_padding, NK_VEC2,
           :image_padding, NK_VEC2,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_SLIDER < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :bar_normal, NK_COLOR,
           :bar_hover, NK_COLOR,
           :bar_active, NK_COLOR,
           :bar_filled, NK_COLOR,
           #
           :cursor_normal, NK_STYLE_ITEM,
           :cursor_hover, NK_STYLE_ITEM,
           :cursor_active, NK_STYLE_ITEM,
           #
           :border, :float,
           :rounding, :float,
           :bar_height, :float,
           :padding, NK_VEC2,
           :spacing, NK_VEC2,
           :cursor_size, NK_VEC2,
           #
           :show_buttons, :int32,
           :inc_button, NK_STYLE_BUTTON,
           :dec_button, NK_STYLE_BUTTON,
           :inc_symbol, NK_SYMBOL_TYPE,
           :dec_symbol, NK_SYMBOL_TYPE,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_PROGRESS < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :cursor_normal, NK_STYLE_ITEM,
           :cursor_hover, NK_STYLE_ITEM,
           :cursor_active, NK_STYLE_ITEM,
           :cursor_border_color, NK_COLOR,
           #
           :rounding, :float,
           :border, :float,
           :cursor_border, :float,
           :cursor_rounding, :float,
           :padding, NK_VEC2,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_SCROLLBAR < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :cursor_normal, NK_STYLE_ITEM,
           :cursor_hover, NK_STYLE_ITEM,
           :cursor_active, NK_STYLE_ITEM,
           :cursor_border_color, NK_COLOR,
           #
           :border, :float,
           :rounding, :float,
           :border_cursor, :float,
           :rounding_cursor, :float,
           :padding, NK_VEC2,
           #
           :show_buttons, :int32,
           :inc_button, NK_STYLE_BUTTON,
           :dec_button, NK_STYLE_BUTTON,
           :inc_symbol, NK_SYMBOL_TYPE,
           :dec_symbol, NK_SYMBOL_TYPE,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_EDIT < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           :scrollbar, NK_STYLE_SCROLLBAR,
           #
           :cursor_normal, NK_COLOR,
           :cursor_hover, NK_COLOR,
           :cursor_text_normal, NK_COLOR,
           :cursor_text_hover, NK_COLOR,
           #
           :text_normal, NK_COLOR,
           :text_hover, NK_COLOR,
           :text_active, NK_COLOR,
           #
           :selected_normal, NK_COLOR,
           :selected_hover, NK_COLOR,
           :selected_text_normal, NK_COLOR,
           :selected_text_hover, NK_COLOR,
           #
           :border, :float,
           :rounding, :float,
           :cursor_size, :float,
           :scrollbar_size, NK_VEC2,
           :padding, NK_VEC2,
           :row_padding, :float
  end

  class NK_STYLE_PROPERTY < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :label_normal, NK_COLOR,
           :label_hover, NK_COLOR,
           :label_active, NK_COLOR,
           #
           :sym_left, NK_SYMBOL_TYPE,
           :sym_right, NK_SYMBOL_TYPE,
           #
           :border, :float,
           :rounding, :float,
           :padding, NK_VEC2,
           #
           :edit, NK_STYLE_EDIT,
           :inc_button, NK_STYLE_BUTTON,
           :dec_button, NK_STYLE_BUTTON,
           #
           :userdata, NK_HANDLE,
           :draw_begin, :nk_draw_begin_f,
           :draw_end, :nk_draw_end_f
  end

  class NK_STYLE_CHART < FFI::Struct
    layout :background, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           :selected_color, NK_COLOR,
           :color, NK_COLOR,
           #
           :border, :float,
           :rounding, :float,
           :padding, NK_VEC2
  end

  class NK_STYLE_COMBO < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           #
           :label_normal, NK_COLOR,
           :label_hover, NK_COLOR,
           :label_active, NK_COLOR,
           #
           :symbol_normal, NK_COLOR,
           :symbol_hover, NK_COLOR,
           :symbol_active, NK_COLOR,
           #
           :button, NK_STYLE_BUTTON,
           :sym_normal, NK_SYMBOL_TYPE,
           :sym_hover, NK_SYMBOL_TYPE,
           :sym_active, NK_SYMBOL_TYPE,
           #
           :border, :float,
           :rounding, :float,
           :content_padding, NK_VEC2,
           :border_padding, NK_VEC2,
           :spacing, NK_VEC2
  end

  class NK_STYLE_TAB < FFI::Struct
    layout :background, NK_STYLE_ITEM,
           :border_color, NK_COLOR,
           :text, NK_COLOR,
           #
           :tab_maximize_button, NK_STYLE_BUTTON,
           :tab_minimize_button, NK_STYLE_BUTTON,
           :node_maximize_button, NK_STYLE_BUTTON,
           :node_minimize_button, NK_STYLE_BUTTON,
           :sym_minimize, NK_SYMBOL_TYPE,
           :sym_maximize, NK_SYMBOL_TYPE,
           #
           :border, :float,
           :rounding, :float,
           :indent, :float,
           :padding, NK_VEC2,
           :spacing, NK_VEC2
  end

  NK_STYLE_HEADER_ALIGN = enum :NK_HEADER_LEFT,
                               :NK_HEADER_RIGHT

  class NK_STYLE_WINDOW_HEADER < FFI::Struct
    layout :normal, NK_STYLE_ITEM,
           :hover, NK_STYLE_ITEM,
           :active, NK_STYLE_ITEM,
           #
           :close_button, NK_STYLE_BUTTON,
           :minimize_button, NK_STYLE_BUTTON,
           :close_symbol, NK_SYMBOL_TYPE,
           :minimize_symbol, NK_SYMBOL_TYPE,
           :maximize_symbol, NK_SYMBOL_TYPE,
           #
           :label_normal, NK_COLOR,
           :label_hover, NK_COLOR,
           :label_active, NK_COLOR,
           #
           :align, NK_STYLE_HEADER_ALIGN,
           :padding, NK_VEC2,
           :label_padding, NK_VEC2,
           :spacing, NK_VEC2
  end

  class NK_STYLE_WINDOW < FFI::Struct
    layout :header, NK_STYLE_WINDOW_HEADER,
           :fixed_background, NK_STYLE_ITEM,
           :background, NK_COLOR,
           #
           :border_color, NK_COLOR,
           :combo_border_color, NK_COLOR,
           :contextual_border_color, NK_COLOR,
           :menu_border_color, NK_COLOR,
           :group_border_color, NK_COLOR,
           :tooltip_border_color, NK_COLOR,
           #
           :scaler, NK_STYLE_ITEM,
           #
           :border, :float,
           :combo_border, :float,
           :contextual_border, :float,
           :menu_border, :float,
           :group_border, :float,
           :tooltip_border, :float,
           #
           :rounding, :float,
           :spacing, NK_VEC2,
           :scrollbar_size, NK_VEC2,
           :min_size, NK_VEC2,
           #
           :padding, NK_VEC2,
           :group_padding, NK_VEC2,
           :popup_padding, NK_VEC2,
           :combo_padding, NK_VEC2,
           :contextual_padding, NK_VEC2,
           :menu_padding, NK_VEC2,
           :tooltip_padding, NK_VEC2
  end

  class NK_STYLE < FFI::Struct
=begin
    layout :font,                   :pointer,
           :cursors,                [:pointer, NK_STYLE_CURSOR[:NK_CURSOR_COUNT]],
           :cursor_acive,           :pointer,
           :cursor_last,            :pointer,
=end
    layout :font,                   NK_USER_FONT.ptr,
           :cursors,                [NK_CURSOR.ptr, NK_STYLE_CURSOR[:NK_CURSOR_COUNT]],
           :cursor_acive,           NK_CURSOR.ptr,
           :cursor_last,            NK_CURSOR.ptr,
           :cursor_visible,         :int32,
           :text,                   NK_STYLE_TEXT,
           :button,                 NK_STYLE_BUTTON,
           :contextual_button,      NK_STYLE_BUTTON,
           :menu_button,            NK_STYLE_BUTTON,
           :option,                 NK_STYLE_TOGGLE,
           :checkbox,               NK_STYLE_TOGGLE,
           :selectable,             NK_STYLE_SELECTABLE,
           :slider,                 NK_STYLE_SLIDER,
           :progress,               NK_STYLE_PROGRESS,
           :property,               NK_STYLE_PROPERTY,
           :edit,                   NK_STYLE_EDIT,
           :chart,                  NK_STYLE_CHART,
           :scrollh,                NK_STYLE_SCROLLBAR,
           :scrollv,                NK_STYLE_SCROLLBAR,
           :tab,                    NK_STYLE_TAB,
           :combo,                  NK_STYLE_COMBO,
           :window,                 NK_STYLE_WINDOW
  end



  #
  # PANEL
  #

  NK_CHART_MAX_SLOT = 4

  class NK_CHART_SLOT < FFI::Struct
    layout :type, NK_CHART_TYPE,
           :color, NK_COLOR,
           :highlight, NK_COLOR,
           :min, :float,
           :max, :float,
           :range, :float,
           :count, :int32,
           :last, NK_VEC2,
           :index, :int32
  end

  class NK_CHART < FFI::Struct
    layout :slots, [NK_CHART_SLOT, NK_CHART_MAX_SLOT],
           :slot, :int32,
           :x, :float,
           :y, :float,
           :w, :float,
           :h, :float
  end

  class NK_ROW_LAYOUT < FFI::Struct
    layout :type, :int32,
           :index, :int32,
           :height, :float,
           :columns, :int32,
           :ratio, :pointer,
           :item_width, :float,
           :item_height,:float,
           :item_offset, :float,
           :filled, :float,
           :item, NK_RECT,
           :tree_depth, :int32
  end

  class NK_POPUP_BUFFER < FFI::Struct
    layout :begin, :nk_size,
           :parent, :nk_size,
           :last, :nk_size,
           :end, :nk_size,
           :active, :int32
  end

  class NK_MENU_STATE < FFI::Struct
    layout :x, :float,
           :y, :float,
           :w, :float,
           :h, :float,
           :offset, NK_SCROLL
  end

  class NK_PANEL < FFI::Struct
    layout :flags, :nk_flags,
           :bounds, NK_RECT,
           :offset, :pointer, # struct nk_scroll *offset;
           :at_x, :float,
           :at_y, :float,
           :max_x, :float,
           :footer_height, :float,
           :header_height, :float,
           :border, :float,
           :has_scrolling, :uint32,
           :clip, NK_RECT,
           :menu, NK_MENU_STATE,
           :row, NK_ROW_LAYOUT,
           :chart, NK_CHART,
           :popup_buffer, NK_POPUP_BUFFER,
           :buffer, :pointer, # struct nk_command_buffer *buffer;
           :parent, :pointer  # struct nk_panel *parent;
  end

  #
  # WINDOW
  #

  NK_WINDOW_MAX_NAME = 64

  NK_WINDOW_FLAGS = enum :NK_WINDOW_PRIVATE,    (1 <<  9),
                         :NK_WINDOW_DYNAMIC,    (1 << 10),
                         :NK_WINDOW_ROM,        (1 << 11),
                         :NK_WINDOW_HIDDEN,     (1 << 12),
                         :NK_WINDOW_CLOSED,     (1 << 13),
                         :NK_WINDOW_MINIMIZED,  (1 << 14),
                         :NK_WINDOW_SUB,        (1 << 15),
                         :NK_WINDOW_GROUP,      (1 << 16),
                         :NK_WINDOW_POPUP,      (1 << 17),
                         :NK_WINDOW_NONBLOCK,   (1 << 18),
                         :NK_WINDOW_CONTEXTUAL, (1 << 19),
                         :NK_WINDOW_COMBO,      (1 << 20),
                         :NK_WINDOW_MENU,       (1 << 21),
                         :NK_WINDOW_TOOLTIP,    (1 << 22),
                         :NK_WINDOW_REMOVE_ROM, (1 << 23)

  class NK_POPUP_STATE < FFI::Struct
    layout :win, :pointer,
           :type, NK_WINDOW_FLAGS,
           :name, :nk_hash,
           :active, :int32,
           :combo_count, :uint32,
           :con_count, :uint32,
           :con_old, :uint32,
           :active_con, :uint32
  end

  class NK_EDIT_STATE < FFI::Struct
    layout :name, :nk_hash,
    :seq, :uint32,
    :old, :uint32,
    :prev, :int32,
    :active, :int32,
    :cursor, :int32,
    :sel_start, :int32,
    :sel_end, :int32,
    :scrollbar, NK_SCROLL,
    :mode, :uint8,
    :single_line, :uint8
  end

  class NK_PROPERTY_STATE < FFI::Struct
    layout :active, :int32,
           :prev, :int32,
           :buffer, [:uint8, NK_MAX_NUMBER_BUFFER],
           :length, :int32,
           :cursor, :int32,
           :name, :nk_hash,
           :seq, :uint32,
           :old, :uint32,
           :state, :int32
  end

  class NK_WINDOW < FFI::Struct
    layout :seq,        :uint32,
           :name,       :nk_hash,
           :name_string, [:uint8, NK_WINDOW_MAX_NAME],
           :flags,      :nk_flags,
           :bounds,     NK_RECT,
           :scrollbar,  NK_SCROLL,
           :buffer,     NK_COMMAND_BUFFER,
           :layout,     :pointer,
           :scrollbar_hiding_timer,  :float,

           # persistent widget state
           :property, NK_PROPERTY_STATE,
           :popup,    NK_POPUP_STATE,
           :edit,     NK_EDIT_STATE,
           :scrolled, :uint32,

           :tables,      :pointer,
           :table_count, :uint16,
           :table_size,  :uint16,

           # window list hooks
           :next_window,   :pointer,  # original : 'next'
           :prev_window,   :pointer,  # original : 'prev'
           :parent_window, :pointer   # original : 'parent'
  end

  #
  # STACK
  #

  NK_BUTTON_BEHAVIOR_STACK_SIZE = 8
  NK_FONT_STACK_SIZE            = 8
  NK_STYLE_ITEM_STACK_SIZE      = 16
  NK_FLOAT_STACK_SIZE           = 32
  NK_VECTOR_STACK_SIZE          = 16
  NK_FLAGS_STACK_SIZE           = 32
  NK_COLOR_STACK_SIZE           = 32

  # NK_CONFIGURATION_STACK_TYPE

  class NK_CONFIG_STACK_STYLE_ITEM_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, NK_STYLE_ITEM
  end

  class NK_CONFIG_STACK_FLOAT_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, :float
  end

  class NK_CONFIG_STACK_VEC2_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, NK_VEC2
  end

  class NK_CONFIG_STACK_FLAGS_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, :nk_flags
  end

  class NK_CONFIG_STACK_COLOR_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, NK_COLOR
  end

  class NK_CONFIG_STACK_USER_FONT_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, NK_USER_FONT
  end

  class NK_CONFIG_STACK_BUTTON_BEHAVIOR_ELEMENT < FFI::Struct
    layout :address,  :pointer,
           :old_value, NK_BUTTON_BEHAVIOR
  end

  # NK_CONFIG_STACK

  class NK_CONFIG_STACK_STYLE_ITEM < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_STYLE_ITEM_ELEMENT, NK_STYLE_ITEM_STACK_SIZE]
  end

  class NK_CONFIG_STACK_FLOAT < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_FLOAT_ELEMENT, NK_FLOAT_STACK_SIZE]
  end

  class NK_CONFIG_STACK_VEC2 < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_VEC2_ELEMENT, NK_VECTOR_STACK_SIZE]
  end

  class NK_CONFIG_STACK_FLAGS < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_FLAGS_ELEMENT, NK_FLAGS_STACK_SIZE]
  end

  class NK_CONFIG_STACK_COLOR < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_COLOR_ELEMENT, NK_COLOR_STACK_SIZE]
  end

  class NK_CONFIG_STACK_USER_FONT < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_USER_FONT_ELEMENT, NK_FONT_STACK_SIZE]
  end

  class NK_CONFIG_STACK_BUTTON_BEHAVIOR < FFI::Struct
    layout :head, :int32,
           :elements, [NK_CONFIG_STACK_BUTTON_BEHAVIOR_ELEMENT, NK_BUTTON_BEHAVIOR_STACK_SIZE]
  end


  class NK_CONFIGURATION_STACKS < FFI::Struct
    layout :style_items, NK_CONFIG_STACK_STYLE_ITEM.by_value,
           :floats, NK_CONFIG_STACK_FLOAT.by_value,
           :vectors, NK_CONFIG_STACK_VEC2.by_value,
           :flags, NK_CONFIG_STACK_FLAGS.by_value,
           :colors, NK_CONFIG_STACK_COLOR.by_value,
           :fonts, NK_CONFIG_STACK_USER_FONT.by_value,
           :button_behaviors, NK_CONFIG_STACK_BUTTON_BEHAVIOR.by_value
  end


  #
  # CONTEXT
  #

  NK_VALUE_PAGE_CAPACITY = ((NK_WINDOW.size / FFI.type_size(:uint32)) / 2)

  class NK_TABLE < FFI::Struct
    layout :seq, :uint32,
           :keys, [:nk_hash, NK_VALUE_PAGE_CAPACITY],
           :values, [:nk_uint, NK_VALUE_PAGE_CAPACITY],
           :next_table, :pointer, # original : 'next'
           :prev_table, :pointer  # original : 'prev'
  end

  class NK_PAGE_DATA < FFI::Union
    layout :tbl, NK_TABLE,
           :win, NK_WINDOW
  end

  class NK_PAGE_ELEMENT < FFI::Struct
    layout :data, NK_PAGE_DATA,
           :next_page_element, :pointer, # original : 'next'
           :prev_page_element, :pointer  # original : 'prev'
  end

  class NK_PAGE < FFI::Struct
    layout :size, :uint32,
           :next_page, :pointer, # original : 'next'
           :win, :pointer # NOTE : Originally defined here is 'struct nk_page_element win[1];'.
  end

  class NK_POOL < FFI::Struct
    layout :alloc, NK_ALLOCATOR,
           :type, NK_ALLOCATION_TYPE,
           :page_count, :uint32,
           :pages, :pointer,
           :freelist, :pointer,
           :capacity, :uint32,
           :size, :nk_size,
           :cap, :nk_size
  end


  class NK_CONTEXT < FFI::Struct
    # public: can be accessed freely
    layout :input, NK_INPUT,
           :style, NK_STYLE,
           :memory, NK_BUFFER,
           :clip, NK_CLIPBOARD,
           :last_widget_state, :nk_flags,
           :delta_time_seconds, :float,
           :button_behavior, NK_BUTTON_BEHAVIOR,
           :stacks, NK_CONFIGURATION_STACKS,

           # private: should only be accessed if you know what you are doing
           #
           :draw_list, NK_DRAW_LIST, # NOTE : available only if NK_INCLUDE_VERTEX_BUFFER_OUTPUT is defined.
           # text editor objects are quite big because of an internal
           # undo/redo stack. Therefore does not make sense to have one for
           # each window for temporary use cases, so I only provide *one* instance
           # for all windows. This works because the content is cleared anyway */
           :text_edit, NK_TEXT_EDIT,
           # draw buffer used for overlay drawing operation like cursor
           :overlay, NK_COMMAND_BUFFER,
           #
           :build, :int32,
           :use_pool, :int32,
           :pool, :pointer,
           :begin, :pointer,    # struct nk_window *
           :end, :pointer,      # struct nk_window *
           :active, :pointer,   # struct nk_window *
           :current, :pointer,  # struct nk_window *
           :freelist, :pointer, # struct nk_page_element *
           :count, :uint32,
           :seq, :uint32
  end



  #
  # Load native library.
  #

  NuklearAPIEntry = Struct.new( :api_name, :api_args, :api_retval )

  @@api_signature = nil

  @@nuklear_import_done = false

  def self.load_lib(libpath = './libnuklear.dylib', output_error = false)
    ffi_lib libpath
    import_symbols(output_error) unless @@nuklear_import_done
  end

  def self.import_symbols(output_error)

    @@api_signature = [

      #
      # API
      #

      # context

      NuklearAPIEntry.new( :nk_init_default, [:pointer, :pointer], :int ), # Note : NK_INCLUDE_DEFAULT_ALLOCATOR
      NuklearAPIEntry.new( :nk_init_fixed, [:pointer, :pointer, :nk_size, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_init_custom, [:pointer, :pointer, :pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_init, [:pointer, :pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_clear, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_free, [:pointer], :void ),

      # window

      NuklearAPIEntry.new( :nk_begin, [:pointer, :pointer, :pointer, NK_RECT.by_value, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_begin_titled, [:pointer, :pointer, :pointer, :pointer, NK_RECT.by_value, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_end, [:pointer], :void ),

      NuklearAPIEntry.new( :nk_window_find, [:pointer, :pointer], NK_WINDOW.by_ref ),
      NuklearAPIEntry.new( :nk_window_get_bounds, [:pointer], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_window_get_position, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_window_get_size, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_window_get_width, [:pointer], :float ),
      NuklearAPIEntry.new( :nk_window_get_height, [:pointer], :float ),
      NuklearAPIEntry.new( :nk_window_get_panel, [:pointer], NK_PANEL.by_ref ),
      NuklearAPIEntry.new( :nk_window_get_content_region, [:pointer], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_window_get_content_region_min, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_window_get_content_region_max, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_window_get_content_region_size, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_window_get_canvas, [:pointer], NK_COMMAND_BUFFER.by_ref ),

      NuklearAPIEntry.new( :nk_window_has_focus, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_collapsed, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_closed, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_hidden, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_active, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_hovered, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_window_is_any_hovered, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_item_is_any_active, [:pointer], :int32 ),

      NuklearAPIEntry.new( :nk_window_set_bounds, [:pointer, NK_RECT.by_value], :void ),
      NuklearAPIEntry.new( :nk_window_set_position, [:pointer, NK_VEC2.by_value], :void ),
      NuklearAPIEntry.new( :nk_window_set_size, [:pointer, NK_VEC2.by_value], :void ),
      NuklearAPIEntry.new( :nk_window_set_focus, [:pointer, :pointer], :void ),

      NuklearAPIEntry.new( :nk_window_close, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_window_collapse, [:pointer, :pointer, NK_COLLAPSE_STATES], :void ),
      NuklearAPIEntry.new( :nk_window_collapse_if, [:pointer, :pointer, NK_COLLAPSE_STATES, :int32], :void ),
      NuklearAPIEntry.new( :nk_window_show, [:pointer, :pointer, NK_SHOW_STATES], :void ),
      NuklearAPIEntry.new( :nk_window_show_if, [:pointer, :pointer, NK_SHOW_STATES, :int32], :void ),

      # Layout

      NuklearAPIEntry.new( :nk_layout_row_dynamic, [:pointer, :float, :int32], :void ),
      NuklearAPIEntry.new( :nk_layout_row_static, [:pointer, :float, :int32, :int32], :void ),

      NuklearAPIEntry.new( :nk_layout_row_begin, [:pointer, NK_LAYOUT_FORMAT, :float, :int32], :void ),
      NuklearAPIEntry.new( :nk_layout_row_push, [:pointer, :float], :void ),
      NuklearAPIEntry.new( :nk_layout_row_end, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_layout_row, [:pointer, NK_LAYOUT_FORMAT, :float, :int32, :pointer], :void ),

      NuklearAPIEntry.new( :nk_layout_space_begin, [:pointer, NK_LAYOUT_FORMAT, :float, :int32], :void ),
      NuklearAPIEntry.new( :nk_layout_space_push, [:pointer, NK_RECT.by_value], :void ),
      NuklearAPIEntry.new( :nk_layout_space_end, [:pointer], :void ),

      NuklearAPIEntry.new( :nk_layout_space_bounds, [:pointer], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_layout_space_to_screen, [:pointer, NK_VEC2.by_value], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_layout_space_to_local, [:pointer, NK_VEC2.by_value], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_layout_space_rect_to_screen, [:pointer, NK_RECT.by_value], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_layout_space_rect_to_local, [:pointer, NK_RECT.by_value], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_layout_ratio_from_pixel, [:pointer, :float], :float ),

      # Layout: Group

      NuklearAPIEntry.new( :nk_group_begin, [:pointer, :pointer, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_group_end, [:pointer], :void ),

      # Layout: Tree

      NuklearAPIEntry.new( :nk_tree_push_hashed, [:pointer, NK_TREE_TYPE, :pointer, NK_COLLAPSE_STATES, :pointer, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_tree_image_push_hashed, [:pointer, NK_TREE_TYPE, NK_IMAGE.by_value, :pointer, NK_COLLAPSE_STATES, :pointer, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_tree_pop, [:pointer], :void ),

      # Widgets

      NuklearAPIEntry.new( :nk_text, [:pointer, :pointer, :int32, :nk_flags], :void ),
      NuklearAPIEntry.new( :nk_text_colored, [:pointer, :pointer, :int32, :nk_flags, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_text_wrap, [:pointer, :pointer, :int32], :void ),
      NuklearAPIEntry.new( :nk_text_wrap_colored, [:pointer, :pointer, :int32, NK_COLOR.by_value], :void ),

      NuklearAPIEntry.new( :nk_label, [:pointer, :pointer, :nk_flags], :void ),
      NuklearAPIEntry.new( :nk_label_colored, [:pointer, :pointer, :nk_flags, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_label_wrap, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_label_colored_wrap, [:pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_image, [:pointer, NK_IMAGE.by_value], :void ),

      # Widgets: Buttons

      NuklearAPIEntry.new( :nk_button_text, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_button_label, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_button_color, [:pointer, NK_COLOR.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_button_symbol, [:pointer, NK_SYMBOL_TYPE], :int32 ),
      NuklearAPIEntry.new( :nk_button_image, [:pointer, NK_IMAGE.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_button_symbol_label, [:pointer, NK_SYMBOL_TYPE, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_button_symbol_text, [:pointer, NK_SYMBOL_TYPE, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_button_image_label, [:pointer, NK_IMAGE.by_value, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_button_image_text, [:pointer, NK_IMAGE.by_value, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_button_set_behavior, [:pointer, NK_BUTTON_BEHAVIOR], :void ),
      NuklearAPIEntry.new( :nk_button_push_behavior, [:pointer, NK_BUTTON_BEHAVIOR], :int32 ),
      NuklearAPIEntry.new( :nk_button_pop_behavior, [:pointer], :int32 ),

      # Widgets: Checkbox

      NuklearAPIEntry.new( :nk_check_label, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_check_text, [:pointer, :pointer, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_check_flags_label, [:pointer, :pointer, :uint32, :uint32], :uint32 ),
      NuklearAPIEntry.new( :nk_check_flags_text, [:pointer, :pointer, :int32, :uint32, :uint32], :uint32 ),
      NuklearAPIEntry.new( :nk_checkbox_label, [:pointer, :pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_checkbox_text, [:pointer, :pointer, :int32, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_checkbox_flags_label, [:pointer, :pointer, :pointer, :uint32], :int32 ),
      NuklearAPIEntry.new( :nk_checkbox_flags_text, [:pointer, :pointer, :int32, :pointer, :uint32], :int32 ),

      # Widgets: Radio

      NuklearAPIEntry.new( :nk_radio_label, [:pointer, :pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_radio_text, [:pointer, :pointer, :int32, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_option_label, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_option_text, [:pointer, :pointer, :int32, :int32], :int32 ),

      # Widgets: Selectable

      NuklearAPIEntry.new( :nk_selectable_label, [:pointer, :pointer, :nk_flags, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_selectable_text, [:pointer, :pointer, :int32, :nk_flags, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_selectable_image_label, [:pointer,NK_IMAGE.by_value,  :pointer, :nk_flags, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_selectable_image_text, [:pointer,NK_IMAGE.by_value, :pointer, :int32, :nk_flags, :pointer], :int32 ),

      NuklearAPIEntry.new( :nk_select_label, [:pointer, :pointer, :nk_flags, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_select_text, [:pointer, :pointer, :int32, :nk_flags, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_select_image_label, [:pointer, NK_IMAGE.by_value,:pointer, :nk_flags, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_select_image_text, [:pointer, NK_IMAGE.by_value,:pointer, :int32, :nk_flags, :int32], :int32 ),

      # Widgets: Slider

      NuklearAPIEntry.new( :nk_slide_float, [:pointer, :float, :float, :float, :float], :float ),
      NuklearAPIEntry.new( :nk_slide_int, [:pointer, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_slider_float, [:pointer, :float, :pointer, :float, :float], :int32 ),
      NuklearAPIEntry.new( :nk_slider_int, [:pointer, :int32, :pointer, :int32, :int32], :int32 ),

      # Widgets: Prograssbar

      NuklearAPIEntry.new( :nk_progress, [:pointer, :pointer, :nk_size, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_prog, [:pointer, :nk_size, :nk_size, :int32], :nk_size ),

      # Widgets: Color picker

      NuklearAPIEntry.new( :nk_color_picker, [:pointer, NK_COLOR.by_value, NK_COLOR_FORMAT], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_color_pick, [:pointer, :pointer, NK_COLOR_FORMAT], :int32 ),

      # Widgets: Property

      NuklearAPIEntry.new( :nk_property_int, [:pointer, :pointer, :int32, :pointer, :int32, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_property_float, [:pointer, :pointer, :float, :pointer, :float, :float, :float], :void ),
      NuklearAPIEntry.new( :nk_property_double, [:pointer, :pointer, :double, :pointer, :double, :float, :float], :void ),
      NuklearAPIEntry.new( :nk_propertyi, [:pointer, :pointer, :int32, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_propertyf, [:pointer, :pointer, :float, :float, :float, :float, :float], :float ),
      NuklearAPIEntry.new( :nk_propertyd, [:pointer, :pointer, :double, :double, :double, :double, :float], :float ),

      # Widgets: TextEdit

      NuklearAPIEntry.new( :nk_edit_string, [:pointer, :nk_flags, :pointer, :pointer, :int32, :nk_plugin_filter], :nk_flags ),
      NuklearAPIEntry.new( :nk_edit_buffer, [:pointer, :nk_flags, :pointer, :nk_plugin_filter], :nk_flags ),
      NuklearAPIEntry.new( :nk_edit_string_zero_terminated, [:pointer, :nk_flags, :pointer, :int32, :nk_plugin_filter], :nk_flags ),

      # Chart

      NuklearAPIEntry.new( :nk_chart_begin, [:pointer, NK_CHART_TYPE, :int32, :float, :float], :int32 ),
      NuklearAPIEntry.new( :nk_chart_begin_colored, [:pointer, NK_CHART_TYPE, NK_COLOR.by_value, NK_COLOR.by_value, :int32, :float, :float], :int32 ),
      NuklearAPIEntry.new( :nk_chart_add_slot, [:pointer, NK_CHART_TYPE, :int32, :float, :float], :void ),
      NuklearAPIEntry.new( :nk_chart_add_slot_colored, [:pointer, NK_CHART_TYPE, NK_COLOR.by_value, NK_COLOR.by_value, :int32, :float, :float], :void ),
      NuklearAPIEntry.new( :nk_chart_push, [:pointer, :float], :nk_flags ),
      NuklearAPIEntry.new( :nk_chart_push_slot, [:pointer, :float, :int32], :nk_flags ),
      NuklearAPIEntry.new( :nk_chart_end, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_plot, [:pointer, NK_CHART_TYPE, :float, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_plot_function, [:pointer, NK_CHART_TYPE, :pointer, :nk_value_getter_f, :int32, :int32], :void ),

      # Popups

      NuklearAPIEntry.new( :nk_popup_begin, [:pointer, :pointer, NK_POPUP_TYPE, :pointer, :nk_flags, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_popup_close, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_popup_end, [:pointer], :void ),

      # Combobox

      NuklearAPIEntry.new( :nk_combo, [:pointer, :pointer, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_separator, [:pointer, :pointer, :int32, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_string, [:pointer, :pointer, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_callback, [:pointer, :nk_item_getter_f, :pointer, :int32, :int32, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combobox, [:pointer, :pointer, :int32, :pointer, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_combobox_string, [:pointer, :pointer, :pointer, :int32, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_combobox_separator, [:pointer, :pointer, :int32, :pointer, :int32, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_combobox_callback, [:pointer, :nk_item_getter_f, :pointer, :pointer, :int32, :int32, :int32], :void ),

      # Combobox: abstract

      NuklearAPIEntry.new( :nk_combo_begin_text, [:pointer, :pointer, :pointer, :int32, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_label, [:pointer, :pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_color, [:pointer, :pointer, NK_COLOR.by_value, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_symbol, [:pointer, :pointer, NK_SYMBOL_TYPE,  :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_symbol_label, [:pointer, :pointer, :pointer, NK_SYMBOL_TYPE, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_symbol_text, [:pointer, :pointer, :pointer, :int32, NK_SYMBOL_TYPE, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_image, [:pointer, :pointer, NK_IMAGE.by_value,  :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_image_label, [:pointer, :pointer, :pointer, NK_IMAGE.by_value, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_begin_image_text, [:pointer, :pointer, :pointer, :int32, NK_IMAGE.by_value, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_label, [:pointer, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_text, [:pointer, :pointer,:int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_image_label, [:pointer, NK_IMAGE.by_value, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_image_text, [:pointer, NK_IMAGE.by_value, :pointer, :int32,:nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_symbol_label, [:pointer, NK_SYMBOL_TYPE, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_item_symbol_text, [:pointer, NK_SYMBOL_TYPE, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_combo_close, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_combo_end, [:pointer], :void ),

      # Contextual

      NuklearAPIEntry.new( :nk_contextual_begin, [:pointer, :pointer, :nk_flags, NK_VEC2.by_value, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_text, [:pointer, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_label, [:pointer, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_image_label, [:pointer, NK_IMAGE.by_value, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_image_text, [:pointer, NK_IMAGE.by_value, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_symbol_label, [:pointer, NK_SYMBOL_TYPE, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_item_symbol_text, [:pointer, NK_SYMBOL_TYPE, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_contextual_close, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_contextual_end, [:pointer], :void ),

      # Tooltip

      NuklearAPIEntry.new( :nk_tooltip, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_tooltip_begin, [:pointer, :pointer, :float], :int32 ),
      NuklearAPIEntry.new( :nk_tooltip_end, [:pointer], :void ),

      # Menu

      NuklearAPIEntry.new( :nk_menubar_begin, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_menubar_end, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_menu_begin_text, [:pointer, :pointer, :pointer, :int32, :nk_flags, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_label, [:pointer, :pointer, :pointer, :nk_flags, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_image, [:pointer, :pointer, :pointer, NK_IMAGE.by_value, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_image_text, [:pointer, :pointer, :pointer, :int32, :nk_flags, NK_IMAGE.by_value, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_image_label, [:pointer, :pointer, :pointer, :nk_flags,NK_IMAGE.by_value, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_symbol, [:pointer, :pointer, :pointer, NK_SYMBOL_TYPE, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_symbol_text, [:pointer, :pointer, :pointer, :int32, :nk_flags, NK_SYMBOL_TYPE, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_begin_symbol_label, [:pointer, :pointer, :pointer, :nk_flags,NK_SYMBOL_TYPE, :float], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_text, [:pointer, :pointer, :int32,:nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_label, [:pointer, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_image_label, [:pointer, NK_IMAGE.by_value, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_image_text, [:pointer, NK_IMAGE.by_value, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_symbol_text, [:pointer, NK_SYMBOL_TYPE, :pointer, :int32, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_item_symbol_label, [:pointer, NK_SYMBOL_TYPE, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_menu_close, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_menu_end, [:pointer], :void ),

      # Drawing

      NuklearAPIEntry.new( :nk_convert, [:pointer, :pointer, :pointer, :pointer, :pointer], :void ), # Note : NK_INCLUDE_VERTEX_BUFFER_OUTPUT
      NuklearAPIEntry.new( :nk__draw_begin, [:pointer, :pointer], NK_DRAW_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk__draw_end, [:pointer, :pointer], NK_DRAW_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk__draw_next, [:pointer, :pointer, :pointer], NK_DRAW_COMMAND.by_ref ),

      # User Input

      NuklearAPIEntry.new( :nk_input_begin, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_input_motion, [:pointer, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_input_key, [:pointer, NK_KEYS, :int32], :void ),
      NuklearAPIEntry.new( :nk_input_button, [:pointer, NK_BUTTONS, :int32, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_input_scroll, [:pointer, :float], :void ),
      NuklearAPIEntry.new( :nk_input_char, [:pointer, :int8], :void ),
      NuklearAPIEntry.new( :nk_input_glyph, [:pointer, NK_GLYPH.by_value], :void ),
      NuklearAPIEntry.new( :nk_input_unicode, [:pointer, :nk_rune], :void ),
      NuklearAPIEntry.new( :nk_input_end, [:pointer], :void ),

      # Style

      NuklearAPIEntry.new( :nk_style_default, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_style_from_table, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_style_load_cursor, [:pointer, NK_STYLE_CURSOR, :pointer], :void ),
      NuklearAPIEntry.new( :nk_style_load_all_cursors, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_style_get_color_by_name, [NK_STYLE_COLORS], :pointer ),
      NuklearAPIEntry.new( :nk_style_set_font, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_style_set_cursor, [:pointer, NK_STYLE_CURSOR], :void ),
      NuklearAPIEntry.new( :nk_style_show_cursor, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_style_hide_cursor, [:pointer], :void ),

      # Style: stack
      NuklearAPIEntry.new( :nk_style_push_font, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_push_float, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_push_vec2, [:pointer, :pointer, NK_VEC2.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_style_push_style_item, [:pointer, :pointer, NK_STYLE_ITEM.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_style_push_flags, [:pointer, :pointer, :nk_flags], :int32 ),
      NuklearAPIEntry.new( :nk_style_push_color, [:pointer, :pointer, NK_COLOR.by_value], :int32 ),

      NuklearAPIEntry.new( :nk_style_pop_font, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_pop_float, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_pop_vec2, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_pop_style_item, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_pop_flags, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_style_pop_color, [:pointer], :int32 ),

      # Utilities

      NuklearAPIEntry.new( :nk_widget_bounds, [:pointer], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_widget_position, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_widget_size, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_widget_is_hovered, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_widget_is_mouse_clicked, [:pointer, NK_BUTTONS], :int32 ),
      NuklearAPIEntry.new( :nk_widget_has_mouse_click_down, [:pointer, NK_BUTTONS, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_spacing, [:pointer, :int32], :void ),

      # base widget function

      NuklearAPIEntry.new( :nk_widget, [:pointer, :pointer], NK_WIDGET_LAYOUT_STATES ),
      NuklearAPIEntry.new( :nk_widget_fitting, [:pointer, :pointer, NK_VEC2.by_value], NK_WIDGET_LAYOUT_STATES ),

      # color (conversion user --> nuklear)
      NuklearAPIEntry.new( :nk_rgb, [:int32, :int32, :int32], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgb_iv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgb_bv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgb_f, [:float, :float, :float], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgb_fv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgb_hex, [:pointer], NK_COLOR.by_value ),

      NuklearAPIEntry.new( :nk_rgba, [:int32, :int32, :int32, :int32], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_u32, [:nk_uint], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_iv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_bv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_f, [:float, :float, :float, :float], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_fv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_rgba_hex, [:pointer], NK_COLOR.by_value ),

      NuklearAPIEntry.new( :nk_hsv, [:int32, :int32, :int32], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsv_iv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsv_bv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsv_f, [:float, :float, :float], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsv_fv, [:pointer], NK_COLOR.by_value ),

      NuklearAPIEntry.new( :nk_hsva, [:int32, :int32, :int32, :int32], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsva_iv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsva_bv, [:pointer], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsva_f, [:float, :float, :float, :float], NK_COLOR.by_value ),
      NuklearAPIEntry.new( :nk_hsva_fv, [:pointer], NK_COLOR.by_value ),

      # color (conversion nuklear --> user)

      NuklearAPIEntry.new( :nk_color_f, [:pointer, :pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_fv, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_u32, [NK_COLOR.by_value], :nk_uint ),
      NuklearAPIEntry.new( :nk_color_hex_rgba, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hex_rgb, [:pointer, NK_COLOR.by_value], :void ),

      NuklearAPIEntry.new( :nk_color_hsv_i, [:pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsv_b, [:pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsv_iv, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsv_bv, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsv_f, [:pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsv_fv, [:pointer, NK_COLOR.by_value], :void ),

      NuklearAPIEntry.new( :nk_color_hsva_i, [:pointer, :pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsva_b, [:pointer, :pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsva_iv, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsva_bv, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsva_f, [:pointer, :pointer, :pointer, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_color_hsva_fv, [:pointer, NK_COLOR.by_value], :void ),

      # image

      NuklearAPIEntry.new( :nk_handle_ptr, [:pointer], NK_HANDLE ),
      NuklearAPIEntry.new( :nk_handle_id, [:int32], NK_HANDLE ),
      NuklearAPIEntry.new( :nk_image_handle, [NK_HANDLE], NK_IMAGE.by_value ),
      NuklearAPIEntry.new( :nk_image_ptr, [:pointer], NK_IMAGE.by_value ),
      NuklearAPIEntry.new( :nk_image_id, [:int32], NK_IMAGE.by_value ),
      NuklearAPIEntry.new( :nk_image_is_subimage, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_subimage_ptr, [:pointer, :ushort, :ushort, NK_RECT.by_value], NK_IMAGE.by_value ),
      NuklearAPIEntry.new( :nk_subimage_id, [:int32, :ushort, :ushort, NK_RECT.by_value], NK_IMAGE.by_value ),
      NuklearAPIEntry.new( :nk_subimage_handle, [NK_HANDLE, :ushort, :ushort, NK_RECT.by_value], NK_IMAGE.by_value ),
      # math

      NuklearAPIEntry.new( :nk_murmur_hash, [:pointer, :int32, :nk_hash], :nk_hash ),
      NuklearAPIEntry.new( :nk_triangle_from_direction, [:pointer, NK_RECT.by_value, :float, :float, NK_HEADING], :void ),

      NuklearAPIEntry.new( :nk_vec2, [:float, :float], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_vec2i, [:int32, :int32], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_vec2v, [:pointer], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_vec2iv, [:pointer], NK_VEC2.by_value ),

      NuklearAPIEntry.new( :nk_get_null_rect, [], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_rect, [:float, :float, :float, :float], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_recti, [:int32, :int32, :int32, :int32], NK_RECTI.by_value ),
      NuklearAPIEntry.new( :nk_recta, [NK_VEC2.by_value, NK_VEC2.by_value], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_rectv, [:pointer], NK_RECT.by_value ),
      NuklearAPIEntry.new( :nk_rectiv, [:pointer], NK_RECTI.by_value ),
      NuklearAPIEntry.new( :nk_rect_pos, [NK_RECT.by_value], NK_VEC2.by_value ),
      NuklearAPIEntry.new( :nk_rect_size, [NK_RECT.by_value], NK_VEC2.by_value ),

      # string

      NuklearAPIEntry.new( :nk_strlen, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_stricmp, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_stricmpn, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_strtoi, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_strtof, [:pointer, :pointer], :float ),
      NuklearAPIEntry.new( :nk_strtod, [:pointer, :pointer], :double ),
      NuklearAPIEntry.new( :nk_strfilter, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_strmatch_fuzzy_string, [:pointer, :pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_strmatch_fuzzy_text, [:pointer, :int32, :pointer, :pointer], :int32 ),

      # UTF-8

      NuklearAPIEntry.new( :nk_utf_decode, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_utf_encode, [:nk_rune, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_utf_len, [:pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_utf_at, [:pointer, :int32, :int32, :pointer, :int32], :pointer ),

      #
      # MEMORY BUFFER
      #

      NuklearAPIEntry.new( :nk_buffer_init_default, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_buffer_init, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_buffer_init_fixed, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_buffer_info, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_buffer_push, [:pointer, NK_BUFFER_ALLOCATION_TYPE, :pointer, :nk_size, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_buffer_mark, [:pointer, NK_BUFFER_ALLOCATION_TYPE], :void ),
      NuklearAPIEntry.new( :nk_buffer_reset, [:pointer, NK_BUFFER_ALLOCATION_TYPE], :void ),
      NuklearAPIEntry.new( :nk_buffer_clear, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_buffer_free, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_buffer_memory, [:pointer], :pointer ),
      NuklearAPIEntry.new( :nk_buffer_memory_const, [:pointer], :pointer ),
      NuklearAPIEntry.new( :nk_buffer_total, [:pointer], :nk_size ),

      #
      # STRING
      #

      NuklearAPIEntry.new( :nk_str_init_default, [:pointer], :void ), # Note : NK_INCLUDE_DEFAULT_ALLOCATOR
      NuklearAPIEntry.new( :nk_str_init, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_str_init_fixed, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_str_clear, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_str_free, [:pointer], :void ),

      NuklearAPIEntry.new( :nk_str_append_text_char, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_append_str_char, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_str_append_text_utf8, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_append_str_utf8, [:pointer, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_str_append_text_runes, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_append_str_runes, [:pointer, :pointer], :int32 ),

      NuklearAPIEntry.new( :nk_str_insert_at_char, [:pointer, :int32, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_at_rune, [:pointer, :int32, :pointer, :int32], :int32 ),

      NuklearAPIEntry.new( :nk_str_insert_text_char, [:pointer, :int32, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_str_char, [:pointer, :int32, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_text_utf8, [:pointer, :int32, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_str_utf8, [:pointer, :int32, :pointer], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_text_runes, [:pointer, :int32, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_str_insert_str_runes, [:pointer, :int32, :pointer], :int32 ),

      NuklearAPIEntry.new( :nk_str_remove_chars, [:pointer, :int32], :void ),
      NuklearAPIEntry.new( :nk_str_remove_runes, [:pointer, :int32], :void ),
      NuklearAPIEntry.new( :nk_str_delete_chars, [:pointer, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_str_delete_runes, [:pointer, :int32, :int32], :void ),

      NuklearAPIEntry.new( :nk_str_at_char, [:pointer, :int32], :pointer ),
      NuklearAPIEntry.new( :nk_str_at_rune, [:pointer, :int32, :pointer, :pointer], :pointer ),
      NuklearAPIEntry.new( :nk_str_rune_at, [:pointer, :int32], :nk_rune ),
      NuklearAPIEntry.new( :nk_str_at_char_const, [:pointer, :int32], :pointer ),
      NuklearAPIEntry.new( :nk_str_at_const, [:pointer, :int32, :pointer, :pointer], :pointer ),

      NuklearAPIEntry.new( :nk_str_get, [:pointer], :pointer ),
      NuklearAPIEntry.new( :nk_str_get_const, [:pointer], :pointer ),
      NuklearAPIEntry.new( :nk_str_len, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_str_len_char, [:pointer], :int32 ),

      #
      # TEXT EDITOR
      #

      # filter function

      NuklearAPIEntry.new( :nk_filter_default, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_ascii, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_float, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_decimal, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_hex, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_oct, [:pointer, :nk_rune], :int32 ),
      NuklearAPIEntry.new( :nk_filter_binary, [:pointer, :nk_rune], :int32 ),

      # text editor

      NuklearAPIEntry.new( :nk_textedit_init_default, [:pointer], :void ), # Note : NK_INCLUDE_DEFAULT_ALLOCATOR
      NuklearAPIEntry.new( :nk_textedit_init, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_textedit_init_fixed, [:pointer, :pointer, :nk_size], :void ),
      NuklearAPIEntry.new( :nk_textedit_free, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_textedit_text, [:pointer, :pointer, :int32], :void ),
      NuklearAPIEntry.new( :nk_textedit_delete, [:pointer, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_textedit_delete_selection, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_textedit_select_all, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_textedit_cut, [:pointer], :int32 ),
      NuklearAPIEntry.new( :nk_textedit_paste, [:pointer, :pointer, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_textedit_undo, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_textedit_redo, [:pointer], :void ),

      #
      # FONT
      #

      NuklearAPIEntry.new( :nk_font_default_glyph_ranges, [], :pointer ),
      NuklearAPIEntry.new( :nk_font_chinese_glyph_ranges, [], :pointer ),
      NuklearAPIEntry.new( :nk_font_cyrillic_glyph_ranges, [], :pointer ),
      NuklearAPIEntry.new( :nk_font_korean_glyph_ranges, [], :pointer ),

      # Font Atlas

      NuklearAPIEntry.new( :nk_font_atlas_init_default, [:pointer], :void ), # Note : NK_INCLUDE_DEFAULT_ALLOCATOR
      NuklearAPIEntry.new( :nk_font_atlas_init, [:pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_font_atlas_init_custom, [:pointer, :pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_font_atlas_begin, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_font_config, [:float], NK_FONT_CONFIG.by_value ),
      NuklearAPIEntry.new( :nk_font_atlas_add, [:pointer, :pointer], NK_FONT.by_ref ),
      NuklearAPIEntry.new( :nk_font_atlas_add_default, [:pointer, :float, :pointer], NK_FONT.by_ref ), # Note : NK_INCLUDE_DEFAULT_FONT
      NuklearAPIEntry.new( :nk_font_atlas_add_from_memory, [:pointer, :pointer, :nk_size, :float, NK_FONT_CONFIG.by_ref], NK_FONT.by_ref ),
      NuklearAPIEntry.new( :nk_font_atlas_add_compressed, [:pointer, :pointer, :nk_size, :float, :pointer], NK_FONT.by_ref ),
      NuklearAPIEntry.new( :nk_font_atlas_add_compressed_base85, [:pointer, :pointer, :float, :pointer], NK_FONT.by_ref ),
      NuklearAPIEntry.new( :nk_font_atlas_bake, [:pointer, :pointer, :pointer, NK_FONT_ATLAS_FORMAT], :pointer ),
      NuklearAPIEntry.new( :nk_font_atlas_end, [:pointer, NK_HANDLE, :pointer], :void ),
      NuklearAPIEntry.new( :nk_font_atlas_clear, [:pointer], :void ),

      # Font

      NuklearAPIEntry.new( :nk_font_find_glyph, [:pointer, :nk_rune], NK_FONT_GLYPH.by_ref ),

      #
      # DRAWING
      #

      # shape outlines

      NuklearAPIEntry.new( :nk_stroke_line, [:pointer, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_curve, [:pointer, :float, :float, :float, :float, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_rect, [:pointer, NK_RECT.by_value, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_circle, [:pointer, NK_RECT.by_value, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_arc, [:pointer, :float, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_triangle, [:pointer, :float, :float, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_polyline, [:pointer, :pointer, :int32, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_stroke_polygon, [:pointer, :pointer, :int32, :float, NK_COLOR.by_value], :void ),

      # filled shades

      NuklearAPIEntry.new( :nk_fill_rect, [:pointer, NK_RECT.by_value, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_fill_rect_multi_color, [:pointer, NK_RECT.by_value, NK_COLOR.by_value, NK_COLOR.by_value, NK_COLOR.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_fill_circle, [:pointer, NK_RECT.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_fill_arc, [:pointer, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_fill_triangle, [:pointer, :float, :float, :float, :float, :float, :float, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_fill_polygon, [:pointer, :pointer, :int32, NK_COLOR.by_value], :void ),

      # misc

      NuklearAPIEntry.new( :nk_push_scissor, [:pointer, NK_RECT.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_image, [:pointer, NK_RECT.by_value, :pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_text, [:pointer, NK_RECT.by_value, :pointer, :int32, :pointer, NK_COLOR.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk__next, [:pointer, :pointer], NK_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk__begin, [:pointer], NK_COMMAND.by_ref ),

      #
      # INPUT
      #

      NuklearAPIEntry.new( :nk_input_has_mouse_click, [:pointer, NK_BUTTONS], :int32 ),
      NuklearAPIEntry.new( :nk_input_has_mouse_click_in_rect, [:pointer, NK_BUTTONS, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_has_mouse_click_down_in_rect, [:pointer, NK_BUTTONS, NK_RECT.by_value, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_click_in_rect, [:pointer, NK_BUTTONS, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_click_down_in_rect, [:pointer, NK_BUTTONS, NK_RECT.by_value, :int32], :int32 ),
      NuklearAPIEntry.new( :nk_input_any_mouse_click_in_rect, [:pointer, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_prev_hovering_rect, [:pointer, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_hovering_rect, [:pointer, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_mouse_clicked, [:pointer, NK_BUTTONS, NK_RECT.by_value], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_down, [:pointer, NK_BUTTONS], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_pressed, [:pointer, NK_BUTTONS], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_mouse_released, [:pointer, NK_BUTTONS], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_key_pressed, [:pointer, NK_KEYS], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_key_released, [:pointer, NK_KEYS], :int32 ),
      NuklearAPIEntry.new( :nk_input_is_key_down, [:pointer, NK_KEYS], :int32 ),

      #
      # DRAW LIST
      #

      # draw list

      NuklearAPIEntry.new( :nk_draw_list_init, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_draw_list_setup, [:pointer, NK_CONVERT_CONFIG.by_ref, :pointer, :pointer, :pointer], :void ),
      NuklearAPIEntry.new( :nk_draw_list_clear, [:pointer], :void ),

      # drawing

      NuklearAPIEntry.new( :nk__draw_list_begin, [:pointer, :pointer], NK_DRAW_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk__draw_list_next, [:pointer, :pointer, :pointer], NK_DRAW_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk__draw_list_end, [:pointer, :pointer], NK_DRAW_COMMAND.by_ref ),
      NuklearAPIEntry.new( :nk_draw_list_clear, [:pointer], :void ),

      # path

      NuklearAPIEntry.new( :nk_draw_list_path_clear, [:pointer], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_line_to, [:pointer, NK_VEC2.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_arc_to_fast, [:pointer, NK_VEC2.by_value, :float, :int32, :int32], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_arc_to, [:pointer, NK_VEC2.by_value, :float, :float, :float, :uint32], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_rect_to, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_curve_to, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, NK_VEC2.by_value, :uint32], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_fill, [:pointer, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_list_path_stroke, [:pointer, NK_COLOR.by_value, NK_DRAW_LIST_STROKE, :float], :void ),

      # stroke

      NuklearAPIEntry.new( :nk_draw_list_stroke_line, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, NK_COLOR.by_value, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_stroke_rect, [:pointer, NK_RECT.by_value, NK_COLOR.by_value, :float, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_stroke_triangle, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, NK_VEC2.by_value, NK_COLOR.by_value, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_stroke_circle, [:pointer, NK_VEC2.by_value, :float, NK_COLOR.by_value, :uint32, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_stroke_curve, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, NK_VEC2.by_value, NK_VEC2.by_value, NK_COLOR.by_value, :uint32, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_stroke_poly_line, [:pointer, NK_VEC2.by_value, :uint32, NK_COLOR.by_value, NK_DRAW_LIST_STROKE, :float, NK_ANTI_ALIASING], :void ),

      # fill

      NuklearAPIEntry.new( :nk_draw_list_fill_rect, [:pointer, NK_RECT.by_value, NK_COLOR.by_value, :float], :void ),
      NuklearAPIEntry.new( :nk_draw_list_fill_rect_multi_color, [:pointer, NK_RECT.by_value, NK_COLOR.by_value, NK_COLOR.by_value, NK_COLOR.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_list_fill_triangle, [:pointer, NK_VEC2.by_value, NK_VEC2.by_value, NK_VEC2.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_list_fill_circle, [:pointer, NK_VEC2.by_value, :float, NK_COLOR.by_value, :uint32], :void ),
      NuklearAPIEntry.new( :nk_draw_list_fill_poly_convex, [:pointer, NK_VEC2.by_value, :uint32, NK_COLOR.by_value, NK_ANTI_ALIASING], :void ),

      # misc

      NuklearAPIEntry.new( :nk_draw_list_add_image, [:pointer, NK_IMAGE.by_value, NK_RECT.by_value, NK_COLOR.by_value], :void ),
      NuklearAPIEntry.new( :nk_draw_list_add_text, [:pointer, :pointer, NK_RECT.by_value, :pointer, :int32, :float, NK_COLOR.by_value], :void ),

      #
      # GUI
      #
      NuklearAPIEntry.new( :nk_style_item_image, [NK_IMAGE.by_value], NK_STYLE_ITEM.by_value ),
      NuklearAPIEntry.new( :nk_style_item_color, [NK_COLOR.by_value], NK_STYLE_ITEM.by_value ),
      NuklearAPIEntry.new( :nk_style_item_hide, [], NK_STYLE_ITEM.by_value ),

    ] # End : @@api_signature


    @@api_signature.each do |sig|
      begin
        attach_function( sig.api_name, sig.api_args, sig.api_retval )
      rescue FFI::NotFoundError
        $stderr.puts("[Warning] Failed to import #{sig}.") if output_error
      end
    end

    @@nuklear_import_done = true

  end

end

=begin
Nuklear-Bindings : A Ruby bindings of Nuklear
Copyright (c) 2016 vaiorabbit

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
=end
