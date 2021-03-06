module Gamework
  class Shape < Gamework::Actor::Base
    # Creates a basic shape based on
    # given type and options.

    attr_reader :type

    def initialize(type, options={})
      @type    = type.intern
      defaults = {
        x: 0, y: 0, z: 1000,
        width:  50,
        height: 50,
        scale:  1,
        angle:  0,
        color:  'white',
        alpha:  255,
        center: false,
        colors: []
      }
      if (pos = options.delete :position)
        options[:x] = pos[0]
        options[:y] = pos[1]
      end
      if (size = options.delete :size)
        options[:width] = size
        options[:height] = size
      end
      super(defaults.merge options)
      @args = []
      make_colors
      make_shape
    end

    def draw
      if triangle?
        Gamework::App.window.draw_triangle(*@args)
      elsif @image
        @_image ||= draw_image
        if @center
          @_image.draw_rot(@x, @y, @z, @angle, 0.5, 0.5, @scale, @scale, @color, :add)
        else
          @_image.draw(@x,@y,@z)
        end
      else
        Gamework::App.window.draw_quad(*@args)
      end
    end

    def get_color(color)
      return color if color.is_a?(Gosu::Color)
      return Gosu::Color.argb(color) if color.is_a?(Fixnum)
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
      x1 = @x
      x2 = @x+@width
      x3 = @x+@width/2
      y1 = @y
      y2 = @y-@height
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
      x1 = @x
      x2 = @x+@width
      y1 = @y
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

    def draw_image
      Gosu::Image.new Gamework::App.window, @image, true, 0, 0, @width, @height
    end

    def set_position(x, y)
      return if pos?(x,y)
      @x, @y = x, y
      make_shape
    end

    def resize(width, height)
      @width, @height = width, height
      make_shape
    end

    def fade(amount)
      self.alpha -= amount
    end

    def alpha=(level)
      @alpha = level
      @alpha = 0 if @alpha < 0
      @alpha = 255 if @alpha > 255
      @color.alpha = level
      @colors.each {|c| c.alpha = level }
    end
  end
end
