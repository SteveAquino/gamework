module Gamework
  class Menu < Gamework::Composite
    # Represents a group of selectable
    # options.  Contians references to
    # a cursor, menu options, and
    # a container.

    attr_reader :cursor_position, :menu_options, :background

    def initialize(options={})
      defaults = {
        x: 0, y: 0, z: 1000,
        width:  options[:size]||100,
        height: options[:size]||28,
        columns: 1,
        justify: :center,
        padding: 0,
        margin: 0,
        menu_options: [],
        fixed:  true
      }
      if (pos = options.delete :position)
        options[:x] = pos[0]
        options[:y] = pos[1]
      end
      set_options(defaults.merge options)
      super()
    end

    def add_background(options={})
      defaults = {
        x: @x, y: @y, z: @z-1,
        width: @width + (@padding*2),
        height: height_with_margin
      }
      @background = Gamework::Shape.new :rectangle, defaults.merge(options)
      add_drawable(@background)
    end

    def add_option(text)
      options = {
        x: @x+@padding,
        y: next_option_y,
        z: @z+1,
        width: @width,
        height: @height,
        justify: @justify
      }
      text = Gamework::Text.new text, options
      @menu_options << text
      add_drawable(text)
    end

    def add_cursor(options={})
      defaults = {
        x: @x+@padding,
        y: @y+@padding,
        z: @z,
        width: @width,
        height: @height,
        color: 0x33ffffff
      }
      @cursor = Gamework::Shape.new :rectangle, defaults.merge(options)
      @cursor_position = 0
      add_drawable(@cursor)
    end


    def move_cursor(direction)
      case direction.intern
      when :up
        return if @cursor_position == 0
        @cursor_position -= 1
      when :down
        return if @cursor_position == (@menu_options.size-1)
        @cursor_position += 1
      end
      full_height = @margin + @height
      y = @y + @padding + (full_height*@cursor_position)
      @cursor.set_position @cursor.x, y
    end

    def next_option_y
      # Calculates the y position of
      # the next option based on the total
      # number of options, margin size,
      # padding, and y position of the menu.

      i = @menu_options.size
      (@height*i) + (@margin*i) + @y + @padding
    end

    def height_with_margin
      # Calculates the total height of all
      # options in the menu, including margin
      # between options and padding around all.

      # Add height for each option's margin
      margins = (@margin * @menu_options.size)
      # Don't add margin below final option
      margins -= @margin if margins > 0
      # Allocate options height and padding
      (@height * @menu_options.size) + margins + (@padding*2)
    end

  end
end