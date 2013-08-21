module Gamework
  class Shape
    # Creates an object that stores

    attr_reader :type, :x, :y, :z, :size, :color, :options

    def initialize(type, options={})
      @type = type.intern
      @x = options[:x] || 0
      @y = options[:y] || 0
      @z = options[:z] || 1000
      @size  = options[:size]  || 50
      @color = options[:color] || 0xffffffff
      @args  = []
      make_color
      make_shape
    end

    def draw
      if triangle?
        Gamework::App.window.draw_triangle(*@args)
      else
        Gamework::App.window.draw_quad(*@args)
      end
    end

    def make_color
      return if @color.is_a?(Fixnum)
      name = @color.upcase
      @color = Gosu::Color.const_get(name)
    end

    def make_shape
      send "make_#{@type}"
    end

    def triangle?
      @type == :triangle
    end

    def make_triangle
      rad = radius
      @args  = [@x-rad, @y+rad, @color, @x+rad, @y+rad, @color, @x, @y-rad, @color, @z]
    end

    def make_square
      rad = radius
      @args = [@x-rad, @y+rad, @color, @x+rad, @y+radius, @color, @x+radius, @y-radius, @color, @x-radius, @y-radius, @color, @z]
    end

    def make_rectangle
    end

    def make_line
    end

    def radius
      @size/2
    end
    
    # draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z = 0, mode = :default)
  end
end