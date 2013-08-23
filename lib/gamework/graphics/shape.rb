module Gamework
  class Shape < Gamework::Drawable
    # Creates a basic shape based on
    # given type and options.

    attr_reader :type, :color, :colors, :options

    def initialize(type, options={})
      @type   = type.intern
      @x      = options[:x]      || 0
      @y      = options[:y]      || 0
      @z      = options[:z]      || 1000
      @width  = options[:width]  || options[:size] || 50
      @height = options[:height] || options[:size] || 50
      @color  = options[:color]  || 0xffffffff
      @colors = options[:colors] || []
      @fixed  = options[:fixed]  || false
      @args   = []
      make_colors
      make_shape
    end

    def draw
      if triangle?
        Gamework::App.window.draw_triangle(*@args)
      else
        Gamework::App.window.draw_quad(*@args)
      end
    end

    def get_color(color)
      return color if color.is_a?(Fixnum)
      return color if color.is_a?(Gosu::Color)
      Gosu::Color.const_get(color.upcase)
    end

    def make_colors
      if @colors.any?
        @colors.map! {|c| get_color(c)}
        @color = @colors.first
      else
        @color = get_color(@color)
      end
    end

    def make_shape
      send "make_#{@type}"
    end

    def triangle?
      @type == :triangle
    end

    def make_triangle
      width  = @width/2
      height = @height/2
      x1 = @x-width
      x2 = @x+width
      x3 = @x
      y1 = @y+height
      y2 = @y-height
      color1 = @colors[0] || @color
      color2 = @colors[1] || @color
      color3 = @colors[2] || @color
      @args  = [x1, y1, color1, x2, y1, color2, x3, y2, color3, @z]
    end

    def make_square
      @height = @width
      make_rectangle
    end

    def make_rectangle
      x1 = @x-@width
      x2 = @x+@width
      y1 = @y-@height
      y2 = @y+@height
      color1 = @colors[0] || @color
      color2 = @colors[1] || @color
      color3 = @colors[2] || @color
      color4 = @colors[3] || @color
      @args = [x1, y1, color1, x1, y2, color2, x2, y2, color3, x2, y1, color4, @z]
    end

    def make_line
    end

    def make_background
      @x = 0
      @y = 0
      @width  = Gamework::App.width
      @height = Gamework::App.height
      make_rectangle
    end
  end
end