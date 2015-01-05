module Gamework
  module StaticSpriteTrait
    def initialize_static_sprite
      @centered ||= false
      @color    ||= 'white'
      @alpha    ||= 255
      @colors   ||= []
      make_colors
    end

    def update_static_sprite
    end

    def draw_static_sprite
      @_sprite ||= draw_sprite
      if @centered
        @_sprite.draw_rot(@x, @y, @z, @angle, 0.5, 0.5, @scale, @scale, @color)
      else
        @_sprite.draw(@x,@y,@z)
      end
    end

    private

    def draw_sprite
      Gosu::Image.new Gamework::App.window, @sprite, true, 0, 0, @width, @height
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

    def alpha=(level)
      @alpha = level
      @alpha = 0 if @alpha < 0
      @alpha = 255 if @alpha > 255
      @color.alpha = level
      @colors.each {|c| c.alpha = level }
    end

    # def make_rectangle
    #   x1 = @x
    #   x2 = @x+@width
    #   y1 = @y
    #   y2 = @y+@height
    #   color1 = @colors[0] || @color
    #   color2 = @colors[1] || @color
    #   color3 = @colors[2] || @color
    #   color4 = @colors[3] || @color
    #   @args = [x1, y1, color1, x1, y2, color2, x2, y2, color3, x2, y1, color4, @z]
    # end
  end
end
