# Represents a group of selectable
# options.  Contians references to
# a cursor, menu options, and
# a container.
#
# Usage:
#   menu = Gamework::Menu.new x: 100, y: 100, width: 300, margin: 10, padding: 10
#   menu.add_option "New Game"
#   menu.add_option "Continue"
#   menu.add_background color: 0xaa000022
#   menu.add_cursor
#   add_drawable menu

module Gamework
  class Menu < Gamework::Composite
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
      super(defaults.merge options)
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
      @cursor_position = next_cursor_index(direction)
      reposition_cursor
    end

    def next_cursor_index(direction)
      # Determine the next possible index
      # for the cursor based for a given
      # direction

      last    = @menu_options.size - 1
      current = @cursor_position
      case direction.intern
      when :up
        current == 0 ? last : current-1
      when :down
        current == last ? 0 : current+1
      end
    end

    def reposition_cursor
      # Reset the cursor shape position
      # based on the current value of
      # cursor_position

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