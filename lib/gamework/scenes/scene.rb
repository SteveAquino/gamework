module Gamework
  class Scene
    # A scene can be thought of as the controller part of
    # a Model View Controller framework.  The scene acts
    # as the delegator for drawing graphics, updating
    # objects, playing sounds, and managing state.

    # include Collection functions to track scenes
    include Gamework::Collection

    # include sound managing API for convenience
    include Gamework::HasSound

    def initialize
      @end_scene = false
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

    def end_scene
      @end_scene = true
    end

    def ended?
      !!@end_scene
    end

    class << self
      # Class Methods

      def update
        # Updates the current Scene instance
        # at the front of the collection

        # First check for and remove the current Scene
        # if it's marked for deletion
        shift if current and current.ended?

        # Update the current Scene in the collection
        current and current.update
      end

      def draw
        # Draws the current Scene instance
        # at the front of the collection

        current and current.draw
      end
    
      def button_down(id)
        # Sends inupt the current Scene instance
        # at the front of the collection

        current and current.button_down(id)
      end

      def current
        # Alias for the first Scene in the collection

        first
      end
    end

  end
end