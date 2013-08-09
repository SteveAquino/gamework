module Gamework
  class Scene
    # A scene can be thought of as the controller part of
    # a Model View Controller framework.  The scene acts
    # as the delegator for drawing graphics, updating
    # objects, playing sounds, and managing state.

    # Include asset management
    include Gamework::HasAssets
    # include sound management
    include Gamework::HasSound
    # Include input management
    include Gamework::HasInput

    attr_reader :tileset

    def initialize
      # @windows = {}
      # @text    = {}
    end

    def update
    end
    
    def draw
      # @windows.values.each {|window| window.draw}
      # @text.values.each do |text_options|
      #   font = text_options[:font_object]  
      #   font.draw(text_options[:text],  text_options[:x],        text_options[:y],
      #             text_options[:z],     text_options[:factor_x], text_options[:factor_y],
      #              text_options[:color], text_options[:mode])
      # end
    end

    def end_scene
      @end_scene = true
    end

    def ended?
      !!@end_scene
    end

    def create_tileset(mapfile, *args)
      @tileset = Gamework::Tileset.create(mapfile, *args)
    end

    def draw_window(id, *args)
      @windows[id] = GameWindow.new(*args)
    end

    def draw_text(id, text, options={}, font_options={})
      options[:x]             ||= 0
      options[:y]             ||= 0
      options[:z]             ||= ZOrder::Text
      options[:factor_x]      ||= 1
      options[:factor_y]      ||= 1
      options[:color]         ||= Colors::Default
      options[:mode]          ||= :default
      options[:font]          ||= {}
      options[:font][:name]   ||= Gosu.default_font_name
      options[:font][:height] ||= Fonts::Menu
      font_object = Gosu::Font.new($game, options[:font][:name], options[:font][:height])
      @text[id] = {
        text: text,
        font_object: font_object
      }.merge(options)
    end

    def update_text(id, text)
      t = @text[id]
      t[:text] = text if t
    end
  end
end