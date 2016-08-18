class Overview
  include Nuklear

  # window flags
  attr_accessor :show_menu, :titlebar, :border, :resize, :movable, :no_scrollbar, :window_flags, :minimizable, :close

  # popups
  attr_accessor :header_align, :show_app_about

  # menubar

  # enum menu_states
  MENU_DEFAULT = 0
  MENU_WINDOWS = 1
  attr_accessor :mprog, :mslider, :mcheck

  # about popup
  attr_accessor :about_popup, :about_popup_rect

  # Widgets
  # enum options
  WIDGETS_A = 0
  WIDGETS_B = 1
  WIDGETS_C = 2
  attr_accessor :widgets_checkbox, :widgets_option

  # Basic widgets
  attr_accessor :int_slider, :float_slider, :prog_value, :property_float, :property_int, :property_neg, :range_float_min, :range_float_max, :range_float_value, :range_int_min, :range_int_max, :range_int_value, :ratio

  def initialize
    # window flags
    @show_menu    = 1  # nk_true
    @titlebar     = 1  # nk_true
    @border       = 1  # nk_true
    @resize       = 1  # nk_true
    @movable      = 1  # nk_true
    @no_scrollbar = 0 # nk_false
    @window_flags = 0 # nk_flags
    @minimizable  = 1  # nk_true
    @close        = 1  # nk_true

    # popups
    @header_align = NK_STYLE_HEADER_ALIGN[:NK_HEADER_RIGHT] # enum nk_style_header_align
    @show_app_about = false # nk_false

    # menubar
    @mprog   = FFI::MemoryPointer.new(:ulong, 1) # nk_size
    @mprog.put_uint64(0, 60)
    @mslider = FFI::MemoryPointer.new(:int32, 1) # int
    @mslider.put_int32(0, 10)
    @mcheck  = FFI::MemoryPointer.new(:int32, 1) # nk_true/nk_false (int)
    @mcheck.put_int32(0, 1) # nk_true

    @prog   = FFI::MemoryPointer.new(:ulong, 1)# size_t
    @prog.put_uint64(0, 40)
    @slider = FFI::MemoryPointer.new(:int32, 1) # int
    @slider.put_int32(0, 10)
    @check  = FFI::MemoryPointer.new(:int32, 1) # nk_true/nk_false (int)
    @check.put_int32(0, 1) # nk_true

    # about popup
    @about_popup = NK_PANEL.new
    @about_popup_rect = nil

    # Widgets
    @widgets_checkbox = FFI::MemoryPointer.new(:int32, 1)
    @widgets_checkbox.put_int32(0, 0)
    @widgets_option = 0

    # Basic widgets
    @int_slider = FFI::MemoryPointer.new(:int32, 1)
    @int_slider.put_int32(0, 5)

    @float_slider = FFI::MemoryPointer.new(:float, 1)
    @float_slider.put_float(0, 2.5)

    @prog_value = FFI::MemoryPointer.new(:ulong, 1)
    @prog_value.put_uint64(0, 40)

    @property_float = FFI::MemoryPointer.new(:float, 1)
    @property_float.put_float(0, 2.0)

    @property_int = FFI::MemoryPointer.new(:int32, 1)
    @property_int.put_int32(0, 10)

    @property_neg = FFI::MemoryPointer.new(:int32, 1)
    @property_neg.put_int32(0, 10)

    @range_float_min = FFI::MemoryPointer.new(:float, 1)
    @range_float_min.put_float(0, 0.0)
    @range_float_max = FFI::MemoryPointer.new(:float, 1)
    @range_float_max.put_float(0, 100.0)
    @range_float_value = FFI::MemoryPointer.new(:float, 1)
    @range_float_value.put_float(0, 50.0)

    @range_int_min = FFI::MemoryPointer.new(:int32, 1)
    @range_int_min.put_int32(0, 0)
    @range_int_max = FFI::MemoryPointer.new(:int32, 1)
    @range_int_max.put_int32(0, 4096)
    @range_int_value = FFI::MemoryPointer.new(:int32, 1)
    @range_int_value.put_int32(0, 2048)

    @ratio = [120, 150]
  end

  def update(ctx)
    window_flags = 0
    ctx[:style][:window][:header][:align] = @header_align
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_BORDER] if @border
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_SCALABLE] if @resize
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_MOVABLE] if @movable 
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_NO_SCROLLBAR] if @no_scrollbar
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_MINIMIZABLE] if @minimizable
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_CLOSABLE] if @close

    menu = NK_PANEL.new
    layout = NK_PANEL.new
    rect = nk_rect(10, 10, 400, 750)
    if nk_begin(ctx, layout, "Overview", rect, window_flags) != 0
      if @show_menu
        # menubar
        nk_menubar_begin(ctx)
        nk_layout_row_begin(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 25, 2)
        nk_layout_row_push(ctx, 45)
        if nk_menu_begin_label(ctx, menu, "MENU", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], 120) != 0
          nk_layout_row_dynamic(ctx, 25, 1)
          @show_menu = 0 if nk_menu_item_label(ctx, "Hide", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) != 0
          @show_app_about = 1 if nk_menu_item_label(ctx, "About", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) != 0
          nk_progress(ctx, @prog, 100, NK_MODIFY[:NK_MODIFIABLE])
          nk_slider_int(ctx, 0, @slider, 16, 1)
          nk_checkbox_label(ctx, "check", @check)
          nk_menu_end(ctx)
        end
        nk_layout_row_push(ctx, 70)
        nk_progress(ctx, @mprog, 100, NK_MODIFY[:NK_MODIFIABLE])
        nk_slider_int(ctx, 0, @mslider, 16, 1)
        nk_checkbox_label(ctx, "check", @mcheck)
        nk_menubar_end(ctx)
      end

      if @show_app_about
        # about popup
        @about_popup_rect = nk_rect(20, 100, 300, 190) if @about_popup_rect == nil
        if nk_popup_begin(ctx, @about_popup, NK_POPUP_TYPE[:NK_POPUP_STATIC], "About", NK_PANEL_FLAGS[:NK_WINDOW_CLOSABLE], @about_popup_rect) != 0
          nk_layout_row_dynamic(ctx, 20, 1)
          nk_label(ctx, "Nuklear", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_label(ctx, "By Micha Mettke", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_label(ctx, "nuklear is licensed under the public domain License.",  NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_popup_end(ctx);
        else
          @show_app_about = false
        end
      end

      # window flags
      if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_TAB], "Window", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
        nk_layout_row_dynamic(ctx, 30, 2)
        tmp = FFI::MemoryPointer.new(:int32, 1)

        nk_checkbox_label(ctx, "Titlebar", tmp.put_int32(0, @titlebar))
        @titlebar = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Menu", tmp.put_int32(0, @show_menu))
        @show_menu = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Border", tmp.put_int32(0, @border))
        @border = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Resizable", tmp.put_int32(0, @resize))
        @resize = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Movable", tmp.put_int32(0, @movable))
        @movable = tmp.get_int32(0)

        nk_checkbox_label(ctx, "No Scrollbar", tmp.put_int32(0, @no_scrollbar))
        @no_scrollbar = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Minimizable", tmp.put_int32(0, @minimizable))
        @minimizable = tmp.get_int32(0)

        nk_checkbox_label(ctx, "Closable", tmp.put_int32(0, @close))
        @close = tmp.get_int32(0)

        nk_tree_pop(ctx)
      end

      if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_TAB], "Widgets", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
        if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Text", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
          # Text Widgets
          nk_layout_row_dynamic(ctx, 20, 1)
          nk_label(ctx, "Label aligned left", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_label(ctx, "Label aligned centered", NK_TEXT_ALIGNMENT[:NK_TEXT_CENTERED])
          nk_label(ctx, "Label aligned right", NK_TEXT_ALIGNMENT[:NK_TEXT_RIGHT])
          nk_label_colored(ctx, "Blue text", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], nk_rgb(0,0,255))
          nk_label_colored(ctx, "Yellow text", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], nk_rgb(255,255,0))
          nk_text(ctx, "Text without /0", 15, NK_TEXT_ALIGNMENT[:NK_TEXT_RIGHT])

          nk_layout_row_static(ctx, 100, 200, 1)
          nk_label_wrap(ctx, "This is a very long line to hopefully get this text to be wrapped into multiple lines to show line wrapping")
          nk_layout_row_dynamic(ctx, 100, 1)
          nk_label_wrap(ctx, "This is another long text to show dynamic window changes on multiline text")
          nk_tree_pop(ctx)
        end

        if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Button", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
          # Buttons Widgets
          nk_layout_row_static(ctx, 30, 100, 3)
          if nk_button_label(ctx, "Button") != 0
            $stdout << "Button pressed!\n"
          end
          nk_button_set_behavior(ctx, NK_BUTTON_BEHAVIOR[:NK_BUTTON_REPEATER])
          if nk_button_label(ctx, "Repeater") != 0
            $stdout << "Repeater is being pressed!\n"
          end
          nk_button_set_behavior(ctx, NK_BUTTON_BEHAVIOR[:NK_BUTTON_DEFAULT])
          nk_button_color(ctx, nk_rgb(0,0,255))

          nk_layout_row_static(ctx, 20, 20, 8)
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_CIRCLE])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_CIRCLE_FILLED])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_RECT])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_RECT_FILLED])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_UP])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_DOWN])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_LEFT])
          nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_RIGHT])

          nk_layout_row_static(ctx, 30, 100, 2)
          nk_button_symbol_label(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_LEFT], "prev", NK_TEXT_ALIGNMENT[:NK_TEXT_RIGHT])
          nk_button_symbol_label(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_RIGHT], "next", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_tree_pop(ctx)
        end

        if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Basic", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
          # Basic widgets
          nk_layout_row_static(ctx, 30, 100, 1)
          nk_checkbox_label(ctx, "Checkbox", @widgets_checkbox)

          nk_layout_row_static(ctx, 30, 80, 3)
          @widgets_option = nk_option_label(ctx, "optionA", @widgets_option == WIDGETS_A ? 1 : 0) ? WIDGETS_A : @widgets_option
          @widgets_option = nk_option_label(ctx, "optionB", @widgets_option == WIDGETS_B ? 1 : 0) ? WIDGETS_B : @widgets_option
          @widgets_option = nk_option_label(ctx, "optionC", @widgets_option == WIDGETS_C ? 1 : 0) ? WIDGETS_C : @widgets_option

          nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 30, 2, @ratio.pack('L2'))
          nk_label(ctx, "Slider int", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) # nk_labelf(ctx, NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], "Slider int") # [NOTE] Ruby-Nuklear does not support nk_labelf (NK_INCLUDE_STANDARD_VARARGS)
          nk_slider_int(ctx, 0, @int_slider, 10, 1)

          nk_label(ctx, "Slider float", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_slider_float(ctx, 0, @float_slider, 5.0, 0.5)
          nk_label(ctx, "Progressbar: #{@prog_value.get_uint64(0)}", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) # nk_labelf(ctx, NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], "Progressbar" , prog_value) # [NOTE] Ruby-Nuklear does not support nk_labelf (NK_INCLUDE_STANDARD_VARARGS)
          nk_progress(ctx, @prog_value, 100, NK_MODIFY[:NK_MODIFIABLE])

          nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 25, 2, @ratio.pack('L2'))
          nk_label(ctx, "Property float:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_property_float(ctx, "Float:", 0, @property_float, 64.0, 0.1, 0.2)
          nk_label(ctx, "Property int:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_property_int(ctx, "Int:", 0, @property_int, 100.0, 1, 1)
          nk_label(ctx, "Property neg:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_property_int(ctx, "Neg:", -10, @property_neg, 10, 1, 1)

          nk_layout_row_dynamic(ctx, 25, 1)
          nk_label(ctx, "Range:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_layout_row_dynamic(ctx, 25, 3)
          nk_property_float(ctx, "#min:",   0, @range_float_min, @range_float_max.get_float(0), 1.0, 0.2)
          nk_property_float(ctx, "#float:", @range_float_min.get_float(0), @range_float_value, @range_float_max.get_float(0), 1.0, 0.2)
          nk_property_float(ctx, "#max:",   @range_float_min.get_float(0), @range_float_max, 100, 1.0, 0.2)

          nk_property_int(ctx, "#min:", -2147483648, @range_int_min, @range_int_max.get_int32(0), 1, 10) # INT_MIN
          nk_property_int(ctx, "#neg:", @range_int_min.get_int32(0), @range_int_value, @range_int_max.get_int32(0), 1, 10)
          nk_property_int(ctx, "#max:", @range_int_min.get_int32(0), @range_int_max, 2147483647, 1, 10) # INT_MAX

          nk_tree_pop(ctx)
        end

        nk_tree_pop(ctx)
      end

      

    end # nk_begin
    nk_end(ctx)

  end # update

end

$overview_state = Overview.new


def overview(ctx)
  $overview_state.update(ctx)
end
