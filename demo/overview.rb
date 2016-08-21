require 'date'

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

  # Selectable List/Grid
  attr_accessor :list_selected, :grid_selected

  # Combobox Widgets
  # default combobox
  attr_accessor :combobox_current_weapon, :combobox_weapons_name
  # slider color combobox
  attr_accessor :combo_color
  # complex color combobox
  COMBO_COLOR_MODE_RGB = 0
  COMBO_COLOR_MODE_HSV = 1
  attr_accessor :combo_color2, :combo_color_mode
  # progressbar combobox
  attr_accessor :combo_progress_a, :combo_progress_b, :combo_progress_c, :combo_progress_d
  # checkbox combobox
  attr_accessor :combo_check_values
  # complex text combobox
  attr_accessor :combo_position
  # chart combobox
  attr_accessor :combo_chart_selection, :combo_chart_values
  # time/date combobox
  attr_accessor :combo_time_selected, :combo_date_selected, :combo_selected_time, :combo_selected_date, :combo_month_list, :combo_week_days_list, :combo_month_days_list

  # Input/Edit
  attr_accessor :edit_field_buffer, :edit_text, :edit_text_len, :edit_box_buffer, :edit_field_len, :edit_box_len

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

    @progress_value = FFI::MemoryPointer.new(:ulong, 1)
    @progress_value.put_uint64(0, 40)

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

    # Selectable List/Grid
    @list_selected = Array.new(4) { FFI::MemoryPointer.new(:int32, 1) }
    # nk_false, nk_false, nk_true, nk_false
    @list_selected[0].put_int32(0, 0)
    @list_selected[1].put_int32(0, 0)
    @list_selected[2].put_int32(0, 1)
    @list_selected[3].put_int32(0, 0)

    @grid_selected = Array.new(16) { FFI::MemoryPointer.new(:int32, 1) }
    @grid_selected[4*0+0].put_int32(0, 1)
    @grid_selected[4*1+1].put_int32(0, 1)
    @grid_selected[4*2+2].put_int32(0, 1)
    @grid_selected[4*3+3].put_int32(0, 1)

    # Combobox Widgets
    # default combobox
    @combobox_current_weapon = 0
    @combobox_weapons_name = ["Fist", "Pistol", "Shotgun", "Plasma", "BFG"]
    # slider color combobox
    @combo_color = nil # nk_rgba(130, 50, 50, 255)
    # complex color combobox
    @combo_color2 = nil # nk_rgba(130, 180, 50, 255)
    @combo_color_mode = COMBO_COLOR_MODE_RGB
    # progressbar combobox
    @combo_progress_a = FFI::MemoryPointer.new(:uint64, 1)
    @combo_progress_b = FFI::MemoryPointer.new(:uint64, 1)
    @combo_progress_c = FFI::MemoryPointer.new(:uint64, 1)
    @combo_progress_d = FFI::MemoryPointer.new(:uint64, 1)
    @combo_progress_a.put_uint64(0, 20)
    @combo_progress_b.put_uint64(0, 40)
    @combo_progress_c.put_uint64(0, 10)
    @combo_progress_d.put_uint64(0, 90)
    # checkbox combobox
    @combo_check_values = Array.new(5) { FFI::MemoryPointer.new(:int32, 1) }
    @combo_check_values.each do |ptr|
      ptr.put_int32(0, 0)
    end
    # complex text combobox
    @combo_position = Array.new(3) { FFI::MemoryPointer.new(:float, 1) }
    @combo_position.each do |ptr|
      ptr.put_float(0, 0.0)
    end
    # chart combobox
    @combo_chart_selection = 8.0
    @combo_chart_values = [26.0, 13.0, 30.0, 15.0, 25.0, 10.0, 20.0, 40.0, 12.0, 8.0, 22.0, 28.0, 5.0]
    # time/date combobox
    @combo_time_selected = false
    @combo_date_selected = false
    @combo_selected_time = Time.now
    @combo_selected_date = Date.today
    @combo_month_list = ["January", "February", "March", "Apil", "May", "June", "July", "August", "September", "Ocotober", "November", "December"]
    @combo_week_days_list  = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    @combo_month_days_list = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Input/Edit
    @edit_field_buffer = ' ' * 64
    @edit_text = Array.new(9) { ' ' * 64 }
    @edit_text_len = Array.new(9) { FFI::MemoryPointer.new(:int32, 1) }
    @edit_text_len.each do |ptr|
      ptr.put_int32(0, 0)
    end
    @edit_box_buffer = ' ' * 512
    @edit_field_len = FFI::MemoryPointer.new(:int32, 1)
    @edit_box_len = FFI::MemoryPointer.new(:int32, 1)

  end

  def update(ctx)
    window_flags = 0
    ctx[:style][:window][:header][:align] = @header_align
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_BORDER] if @border != 0
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_SCALABLE] if @resize != 0
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_MOVABLE] if @movable != 0
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_NO_SCROLLBAR] if @no_scrollbar != 0
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_MINIMIZABLE] if @minimizable != 0
    window_flags |= NK_PANEL_FLAGS[:NK_WINDOW_CLOSABLE] if @close != 0

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
          nk_popup_end(ctx)
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
          @widgets_option = nk_option_label(ctx, "optionA", @widgets_option == WIDGETS_A ? 1 : 0) != 0 ? WIDGETS_A : @widgets_option
          @widgets_option = nk_option_label(ctx, "optionB", @widgets_option == WIDGETS_B ? 1 : 0) != 0 ? WIDGETS_B : @widgets_option
          @widgets_option = nk_option_label(ctx, "optionC", @widgets_option == WIDGETS_C ? 1 : 0) != 0 ? WIDGETS_C : @widgets_option

          nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 30, 2, @ratio.pack('F2'))
          nk_label(ctx, "Slider int", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) # nk_labelf(ctx, NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], "Slider int") # [NOTE] Ruby-Nuklear does not support nk_labelf (NK_INCLUDE_STANDARD_VARARGS)
          nk_slider_int(ctx, 0, @int_slider, 10, 1)

          nk_label(ctx, "Slider float", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_slider_float(ctx, 0, @float_slider, 5.0, 0.5)
          nk_label(ctx, "Progressbar: #{@progress_value.get_uint64(0)}", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT]) # nk_labelf(ctx, NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], "Progressbar" , progress_value) # [NOTE] Ruby-Nuklear does not support nk_labelf (NK_INCLUDE_STANDARD_VARARGS)
          nk_progress(ctx, @progress_value, 100, NK_MODIFY[:NK_MODIFIABLE])

          nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 25, 2, @ratio.pack('F2'))
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

      if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Selectable", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
        if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "List", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
          nk_layout_row_static(ctx, 18, 100, 1)
          nk_selectable_label(ctx, "Selectable", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], @list_selected[0])
          nk_selectable_label(ctx, "Selectable", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], @list_selected[1])
          nk_label(ctx, "Not Selectable", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          nk_selectable_label(ctx, "Selectable", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], @list_selected[2])
          nk_selectable_label(ctx, "Selectable", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT], @list_selected[3])
          nk_tree_pop(ctx)
        end
        if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Grid", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
          nk_layout_row_static(ctx, 50, 50, 4)
          for i in 0...16
            if nk_selectable_label(ctx, "Z", NK_TEXT_ALIGNMENT[:NK_TEXT_CENTERED], @grid_selected[i]) != 0
              x = (i % 4)
              y = i / 4
              @grid_selected[i - 1].put_int32(0, @grid_selected[i - 1].get_int32(0) ^ 1) if x < 3
              @grid_selected[i + 1].put_int32(0, @grid_selected[i + 1].get_int32(0) ^ 1) if x < 3
              @grid_selected[i - 4].put_int32(0, @grid_selected[i - 4].get_int32(0) ^ 1) if y > 0
              @grid_selected[i + 4].put_int32(0, @grid_selected[i + 4].get_int32(0) ^ 1) if y < 3
            end
          end
          nk_tree_pop(ctx)
        end
        nk_tree_pop(ctx)
      end

      # Combobox Widgets
      if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Combo", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0

        combo = NK_PANEL.new

        # default combobox
        nk_layout_row_static(ctx, 25, 200, 1)
        @combobox_current_weapon = nk_combo(ctx, @combobox_weapons_name.pack('p*'), @combobox_weapons_name.size, @combobox_current_weapon, 25)

        # slider color combobox
        @combo_color = nk_rgba(130, 50, 50, 255) if @combo_color == nil
        if nk_combo_begin_color(ctx, combo, @combo_color, 200) != 0
          nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_DYNAMIC], 30, 2, [0.15, 0.85].pack('F2'))
          nk_label(ctx, "R:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          @combo_color[:r] = nk_slide_int(ctx, 0, @combo_color[:r], 255, 5)
          nk_label(ctx, "G:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          @combo_color[:g] = nk_slide_int(ctx, 0, @combo_color[:g], 255, 5)
          nk_label(ctx, "B:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          @combo_color[:b] = nk_slide_int(ctx, 0, @combo_color[:b], 255, 5)
          nk_label(ctx, "A:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
          @combo_color[:a] = nk_slide_int(ctx, 0, @combo_color[:a], 255, 5)
          nk_combo_end(ctx)
        end

        # complex color combobox
        @combo_color2 = nk_rgba(130, 180, 50, 255) if @combo_color2 == nil
        if nk_combo_begin_color(ctx, combo, @combo_color2, 400) != 0
          #ifndef DEMO_DO_NOT_USE_COLOR_PICKER
          # nk_layout_row_dynamic(ctx, 120, 1)
          # @combo_color2 = nk_color_picker(ctx, @combo_color2, NK_COLOR_FORMAT[:NK_RGBA])
          #endif

          nk_layout_row_dynamic(ctx, 25, 2)
          @combo_color_mode = nk_option_label(ctx, "RGB", (@combo_color_mode == COMBO_COLOR_MODE_RGB) ? 1 : 0) != 0 ? COMBO_COLOR_MODE_RGB : @combo_color_mode
          @combo_color_mode = nk_option_label(ctx, "HSV", (@combo_color_mode == COMBO_COLOR_MODE_HSV) ? 1 : 0) != 0 ? COMBO_COLOR_MODE_HSV : @combo_color_mode
          nk_layout_row_dynamic(ctx, 25, 1)
          if @combo_color_mode == COMBO_COLOR_MODE_RGB
            @combo_color2[:r] = nk_propertyi(ctx, "#R:", 0, @combo_color2[:r], 255, 1,1)
            @combo_color2[:g] = nk_propertyi(ctx, "#G:", 0, @combo_color2[:g], 255, 1,1)
            @combo_color2[:b] = nk_propertyi(ctx, "#B:", 0, @combo_color2[:b], 255, 1,1)
            @combo_color2[:a] = nk_propertyi(ctx, "#A:", 0, @combo_color2[:a], 255, 1,1)
          else
            tmp = FFI::MemoryPointer.new(:uint8, 4)
            nk_color_hsva_bv(tmp, @combo_color2)
            tmp.put_uint8(0, nk_propertyi(ctx, "#H:", 0, tmp.get_uint8(0), 255, 1,1))
            tmp.put_uint8(1, nk_propertyi(ctx, "#S:", 0, tmp.get_uint8(1), 255, 1,1))
            tmp.put_uint8(2, nk_propertyi(ctx, "#V:", 0, tmp.get_uint8(2), 255, 1,1))
            tmp.put_uint8(3, nk_propertyi(ctx, "#A:", 0, tmp.get_uint8(3), 255, 1,1))
            @combo_color2 = nk_hsva_bv(tmp)
          end
          nk_combo_end(ctx)
        end

        # progressbar combobox
        sum = @combo_progress_a.get_uint64(0) + @combo_progress_b.get_uint64(0) + @combo_progress_c.get_uint64(0) + @combo_progress_d.get_uint64(0)
        if nk_combo_begin_label(ctx, combo, sum.to_s, 200) != 0
          nk_layout_row_dynamic(ctx, 30, 1)
          nk_progress(ctx, @combo_progress_a, 100, NK_MODIFY[:NK_MODIFIABLE])
          nk_progress(ctx, @combo_progress_b, 100, NK_MODIFY[:NK_MODIFIABLE])
          nk_progress(ctx, @combo_progress_c, 100, NK_MODIFY[:NK_MODIFIABLE])
          nk_progress(ctx, @combo_progress_d, 100, NK_MODIFY[:NK_MODIFIABLE])
          nk_combo_end(ctx)
        end

        # checkbox combobox
        sum = @combo_check_values[0].get_int32(0) + @combo_check_values[1].get_int32(0) + @combo_check_values[2].get_int32(0) + @combo_check_values[3].get_int32(0) + @combo_check_values[4].get_int32(0)
        if nk_combo_begin_label(ctx, combo, sum.to_s, 200) != 0
          nk_layout_row_dynamic(ctx, 30, 1)
          nk_checkbox_label(ctx, @combobox_weapons_name[0], @combo_check_values[0])
          nk_checkbox_label(ctx, @combobox_weapons_name[1], @combo_check_values[1])
          nk_checkbox_label(ctx, @combobox_weapons_name[2], @combo_check_values[2])
          nk_checkbox_label(ctx, @combobox_weapons_name[3], @combo_check_values[3])
          nk_combo_end(ctx)
        end

        # complex text combobox
        buffer = sprintf("%.2f, %.2f, %.2f", @combo_position[0].get_float(0), @combo_position[1].get_float(0),@combo_position[2].get_float(0))
        if nk_combo_begin_label(ctx, combo, buffer, 200) != 0
          nk_layout_row_dynamic(ctx, 25, 1)
          nk_property_float(ctx, "#X:", -1024.0, @combo_position[0], 1024.0, 1, 0.5)
          nk_property_float(ctx, "#Y:", -1024.0, @combo_position[1], 1024.0, 1, 0.5)
          nk_property_float(ctx, "#Z:", -1024.0, @combo_position[2], 1024.0, 1, 0.5)
          nk_combo_end(ctx)
        end

        # chart combobox
        buffer = sprintf("%.1f", @combo_chart_selection)
        if nk_combo_begin_label(ctx, combo, buffer, 250) != 0
          nk_layout_row_dynamic(ctx, 150, 1)
          nk_chart_begin(ctx, NK_CHART_TYPE[:NK_CHART_COLUMN], @combo_chart_values.size, 0, 50)
          @combo_chart_values.each do |val|
            res = nk_chart_push(ctx, val)
            if (res & NK_CHART_EVENT[:NK_CHART_CLICKED]) != 0
              @combo_chart_selection = val
              nk_combo_close(ctx)
              break
            end
          end
          nk_chart_end(ctx)
          nk_combo_end(ctx)
        end

        # time/date combobox
        if !@combo_time_selected || !@combo_date_selected
          @combo_selected_time = Time.now if !@combo_time_selected
          @combo_selected_date = Date.today if !@combo_date_selected
        end
        # time combobox
        buffer = sprintf("%02d:%02d:%02d", @combo_selected_time.hour, @combo_selected_time.min, @combo_selected_time.sec)
        if nk_combo_begin_label(ctx, combo, buffer, 250) != 0
          @combo_time_selected = true
          nk_layout_row_dynamic(ctx, 25, 1)
          selected_time_sec = nk_propertyi(ctx, "#S:", 0, @combo_selected_time.sec, 60, 1, 1)
          selected_time_min = nk_propertyi(ctx, "#M:", 0, @combo_selected_time.min, 60, 1, 1)
          selected_time_hour = nk_propertyi(ctx, "#H:", 0, @combo_selected_time.hour, 23, 1, 1)
          @combo_selected_time = Time.new(@combo_selected_time.year, @combo_selected_time.month, @combo_selected_time.day,
                                          selected_time_hour, selected_time_min, selected_time_sec)
          nk_combo_end(ctx)
        end

        # date combobox
        nk_layout_row_static(ctx, 25, 350, 1)
        buffer = sprintf("%02d-%02d-%02d", @combo_selected_date.mday, @combo_selected_date.mon, @combo_selected_date.year)
        if nk_combo_begin_label(ctx, combo, buffer, 400) != 0
          year = @combo_selected_date.year
          leap_year = (((year % 4 == 0) && ((year % 100 != 0))) || (year % 400 == 0)) ? 1 : 0
          days = @combo_month_days_list[@combo_selected_date.mon-1]
          days += leap_year if @combo_selected_date.mon == 2

          # header with month and year
          @combo_date_selected = true
          nk_layout_row_begin(ctx, NK_LAYOUT_FORMAT[:NK_DYNAMIC], 20, 3)
          nk_layout_row_push(ctx, 0.05)
          selected_date_mon  = @combo_selected_date.mon
          selected_date_year = @combo_selected_date.year
          selected_date_mday = @combo_selected_date.mday
          if nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_LEFT]) != 0
            if selected_date_mon == 1
              selected_date_mon = 12
              selected_date_year = [0, selected_date_year-1].max
            else
              selected_date_mon -= 1
            end
          end
          nk_layout_row_push(ctx, 0.9)
          buffer = sprintf("%s %d", @combo_month_list[selected_date_mon-1], year)
          nk_label(ctx, buffer, NK_TEXT_ALIGNMENT[:NK_TEXT_CENTERED])
          nk_layout_row_push(ctx, 0.05)
          if nk_button_symbol(ctx, NK_SYMBOL_TYPE[:NK_SYMBOL_TRIANGLE_RIGHT]) != 0
            if selected_date_mon == 12
              selected_date_mon = 1
              selected_date_year += 1
            else
              selected_date_mon += 1
            end
          end
          nk_layout_row_end(ctx)
          year_n = (selected_date_mon <= 2) ? year-1 : year
          y = year_n % 100
          c = year_n / 100
          y4 = (y.to_f / 4).to_i
          c4 = (c.to_f / 4).to_i
          m = (2.6 * (((selected_date_mon-1 + 10) % 12).to_f + 1) - 0.2).to_i
          week_day = (((1 + m + y + y4 + c4 - 2 * c) % 7) + 7) % 7

          # weekdays
          nk_layout_row_dynamic(ctx, 35, 7)
          @combo_week_days_list.each do |wd|
            nk_label(ctx, wd, NK_TEXT_ALIGNMENT[:NK_TEXT_CENTERED])
          end
          # days
          nk_spacing(ctx, week_day) if week_day > 0
          (1..days).each do |i|
            buffer = sprintf("%d", i)
            if nk_button_label(ctx, buffer) != 0
              selected_date_mday = i
              nk_combo_close(ctx)
            end
          end

          begin
            @combo_selected_date = Date.new(selected_date_year, selected_date_mon, selected_date_mday)
          rescue
            # catch 'invalid date (ArgumentError)' exception (2016-02-30, 2016-06-31, etc.)
            selected_date_mday = @combo_month_days_list[selected_date_mon-1]
            @combo_selected_date = Date.new(selected_date_year, selected_date_mon, selected_date_mday)
          end

          nk_combo_end(ctx)
        end

        nk_tree_pop(ctx)

      end # Combobox Widgets

      # Input/Edit
      if nk_tree_push(ctx, NK_TREE_TYPE[:NK_TREE_NODE], "Input", NK_COLLAPSE_STATES[:NK_MINIMIZED]) != 0
        nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 25, 2, @ratio.pack('F2'))
        nk_label(ctx, "Default:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])

        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[0], @edit_text_len[0], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_default'))
        nk_label(ctx, "Int:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[1], @edit_text_len[1], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_decimal'))
        nk_label(ctx, "Float:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[2], @edit_text_len[2], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_float'))
        nk_label(ctx, "Hex:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[4], @edit_text_len[4], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_hex'))
        nk_label(ctx, "Octal:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[5], @edit_text_len[5], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_oct'))
        nk_label(ctx, "Binary:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_SIMPLE], @edit_text[6], @edit_text_len[6], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_binary'))

        nk_label(ctx, "Password:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        begin
          old_len = @edit_text_len[8].get_int32(0)
          buffer = '*' * @edit_text_len[8].get_int32(0) + ' ' * (64 - @edit_text_len[8].get_int32(0))
          nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_FIELD], buffer, @edit_text_len[8], 64, Nuklear.ffi_libraries[0].find_function('nk_filter_default'))
          growth = @edit_text_len[8].get_int32(0) - old_len
          if growth > 0
            @edit_text[8] = @edit_text[8][0...old_len] + buffer[old_len...(old_len+growth)]
          end
        end

        nk_label(ctx, "Field:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_FIELD], @edit_field_buffer, @edit_field_len, 64, Nuklear.ffi_libraries[0].find_function('nk_filter_default'))

        nk_label(ctx, "Box:", NK_TEXT_ALIGNMENT[:NK_TEXT_LEFT])
        nk_layout_row_static(ctx, 180, 278, 1)
        nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_BOX], @edit_box_buffer, @edit_box_len, 512, Nuklear.ffi_libraries[0].find_function('nk_filter_default'))

        nk_layout_row(ctx, NK_LAYOUT_FORMAT[:NK_STATIC], 25, 2, @ratio.pack('F2'))
        active = nk_edit_string(ctx, NK_EDIT_TYPES[:NK_EDIT_FIELD]|NK_EDIT_FLAGS[:NK_EDIT_SIG_ENTER], @edit_text[7], @edit_text_len[7], 64,  Nuklear.ffi_libraries[0].find_function('nk_filter_ascii'))
        if nk_button_label(ctx, "Submit") != 0 || (active & NK_EDIT_EVENTS[:NK_EDIT_COMMITED]) != 0
          @edit_text[7][@edit_text_len[7].get_int32(0)] = "\n"
          @edit_text_len[7].put_int32(0, @edit_text_len[7].get_int32(0) + 1)
          @edit_box_buffer = @edit_box_buffer[0...@edit_box_len.get_int32(0)] + @edit_text[7][0...@edit_text_len[7].get_int32(0)]
          @edit_box_len.put_int32(0, @edit_box_len.get_int32(0) + @edit_text_len[7].get_int32(0))
          @edit_text_len[7].put_int32(0, 0)
        end
        nk_layout_row_end(ctx)
        nk_tree_pop(ctx)
      end

      # [TODO]
      # - Chart
      # - Popup
      # - Layout

    end # nk_begin

    nk_end(ctx)

  end # update

end

$overview_state = Overview.new

def overview(ctx)
  $overview_state.update(ctx)
end
