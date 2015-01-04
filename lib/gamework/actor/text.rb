module Gamework
  class Text < Gamework::Actor::Base
    # Represents on screen game text using
    # Gosu::Font and Drawable methods
    #
    # Font height is controlled with the
    # @height attribute

    attr_reader :text

    def initialize(text, options={})
      @text    = text
      defaults = {
        z: 1000,
        height: 30,
        factor_x: 1,
        factor_y: 1,
        color:  0xffffffff,
        mode: :default,
        justify: :left,
        font_name: Gosu.default_font_name
      }
      super(defaults.merge options)
      make_font
    end

    def make_font
      # Makes an instance of Gosu::Font
      
      @font = Gosu::Font.new(Gamework::App.window, @font_name, @height)
    end

    def draw
      x = @x + offset_x
      @font.draw(@text, x, @y, @z, @factor_x, @factor_y, @color, @mode)
    end

    def offset_x
      # Determine the offset for
      # justified font

      case @justify
      when :left
        0
      when :right
        @width - font_width
      when :center
        (@width - font_width)/2
      end
    end

    def font_width
      # Ties into Gosu::Font#text_width
      # to calculate the visual size
      # of the rendered font

      @font.text_width(@text, @factor_x)
    end

    def update_text(text)
      @text = text
    end
  end
end
