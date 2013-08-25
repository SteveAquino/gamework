module Gamework
  class Text < Gamework::Drawable
    # Represents on screen game text

    attr_reader :text

    def initialize(text, options={})
      @text    = text
      defaults = {
        x: 0, y: 0, z: 1000,
        width:  30,
        height: 30,
        color:  0xffffffff,
        factor_x: 1,
        factor_y: 1,
        mode: :default,
        font_name: Gosu.default_font_name,
        justify: :left,
        fixed:  false
      }
      if (size = options.delete :size)
        options[:width] = size
        options[:height] = size
      end
      set_options(defaults.merge options)
      make_font
    end

    def make_font
      @font = Gosu::Font.new(Gamework::App.window, @font_name, @height)
    end

    def draw
      x = @x + offset_x
      @font.draw(@text, x, @y, @z, @factor_x, @factor_y, @color, @mode)
    end

    def offset_x
      case @justify
      when :left
        0
      when :right
        @width - @font.text_width(@text, @factor_x)
      when :center
        (@width - @font.text_width(@text, @factor_x))/2
      end
    end

    def update_text(text)
      @text = text
    end
  end
end