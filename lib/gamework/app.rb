require "active_support/core_ext/string/inflections"

module Gamework
  module App
    # The Gamework::App module bridges the gap between
    # the current window, player input, and the current
    # scene.  There is a pointer to a single instance
    # of a window and the current scene.  Scenes can
    # be prepared before the game loads or during
    # exectution of another Scene.

    # This singleton contains the only reference
    # to a Gosu::Window instance, required for many
    # of the library's functions.

    @@scenes = []

    class << self

      @showing = false
      attr_reader :window, :logger
      attr_accessor :width, :height, :fullscreen, :debug, :title, :caption, :log_file

      # Delegate update to the current scene,
      # called once per frame
      def update
        # Remove the current Scene if it's marked for deletion
        @@scenes.shift if current_scene and current_scene.ended?
        # Update the current scene if it exists, otherwise exit
      	current_scene ? current_scene.update : exit
      end

      # Delegate draw to the current scene,
      # called once per frame
      def draw
				current_scene and current_scene.draw
      end

      # Delegate input to the current scene
      def button_down(id)
        current_scene and current_scene.button_down(id)
      end

      # Delegate input to the current scene
      def button_up(id)
        current_scene and current_scene.button_up(id)
      end

      def make_window
        @window ||= Gamework::Window.new(@width, @height, !!@fullscreen)
        set_default_caption
      end

      def make_logger(log_file=nil)
        @logger ||= Gamework::Logger.new(log_file)
      end

      # Sets a caption on the window
      def set_default_caption
        self.caption ||= @title
      end

      # Calls Gosu::Window#show which opens
      # the game window and begins the loop
      def show
        @showing = true
        window.show
      end

      def showing?
        @showing
      end

      # Creates a new window and starts
      # the main game loop with an optional
      # block called before.
      def start
        # Don't allow the game to start twice
        raise "The game has already started." if showing?

        Gamework::ENV ||= 'development'
        # Make logger and start game
        make_logger(@log_file)
        @logger.info 'Starting the game'

        # Allow optional before block
        yield if block_given?

        @logger.info 'Opening a native window'
        make_window

        @logger.info 'Starting render loop'
        show
      end

      def exit
        @logger.info 'Exiting game'
        @showing = false
        @window.close
      end

      # Empties the scene collection to
      # allow the game and current scene
      # to close on the next update
      def quit
        scene = current_scene
        scene.end_scene
        @@scenes = [scene]
      end

      # Allow block style configuration settings, ie:
      #
      # config.do |c|
      #   c.width  = 800
      #   c.height = 640
      # end
      def config(&block)
        # Raise error if the window is already drawn
        raise_config_error if showing?
        yield(Gamework::App)
      end

      def current_scene
      	@@scenes.first
      end

      def add_scene(scene)
        if scene.kind_of? String
          # Convert strings to classes
          scene = string_to_scene_class(scene)
        end
        @@scenes.push(scene.new)
      end

      def <<(scene)
        add_scene(scene)
      end

      def end_current_scene
    		current_scene and current_scene.end_scene
      end

      def next_scene(scene)
        # End the current scene and
        # load another into the array

        end_current_scene
        add_scene(scene)
      end

      def string_to_scene_class(string)
        # Converts a string into a scene class

        base = string.titleize.gsub(' ', '')
        "#{base}Scene".constantize
      end

      # Define class level accessor methods for
      # easy configuration settings, but raise
      # error if the window is already drawn

      def raise_config_error
        raise "Can't set configuration settings after the game has started."
      end

      def width=(val)
        raise_config_error if showing?
        @width = val
      end

      def height=(val)
        raise_config_error if showing?
        @height = val
      end

      def fullscreen=(val)
        raise_config_error if showing?
        @fullscreen = val
      end

      def title=(val)
        raise_config_error if showing?
        @title = val
      end

      def log_file=(val)
        raise_config_error if showing?
        @log_file = val
      end

      def caption=(val)
        @caption = val
        window && window.caption = val
      end

      def debug_mode?
        !!@debug
      end

      def debug=(val)
        raise_config_error if showing?
        @debug = val
      end

      def center_x
        @width/2
      end

      def center_y
        @height/2
      end

      def center
        [center_x, center_y]
      end
    end

  end
end