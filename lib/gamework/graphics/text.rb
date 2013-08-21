module Gamework
  class Text
    # Represents on screen game text

    attr_reader :text, :font_name, :height,
                :x, :y, :z, :color

    def initialize(text, options)
      @text      = text
      @x         = options[:x] || 0
      @y         = options[:y] || 0
      @z         = options[:z] || 1000
      @color     = options[:color]     || 0xffffffff
      @factor_x  = options[:factor_x]  || 1
      @factor_y  = options[:factor_y]  || 1
      @font_name = options[:font_name] || Gosu.default_font_name
      @size      = options[:size]      || 30
      @mode      = options[:mode]      || :default

      make_font
    end

    def make_font
      @font = Gosu::Font.new(Gamework::App.window, @font_name, @size)
    end

    def draw
      @font.draw(@text, @x, @y, @z, @factor_x, @factor_y, @color, @mode)
    end

    def update(text)
      @text = text
    end
  end
end