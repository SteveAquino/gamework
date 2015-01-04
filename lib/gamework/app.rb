require "active_support/core_ext/string/inflections"

# The Gamework::App module bridges the gap between
# the current window, player input, and the current
# scene.  There is a pointer to a single instance
# of a window and the current scene.  Scenes can
# be prepared before the game loads or during
# exectution of another Scene.

# This singleton contains the only reference
# to a Gosu::Window instance, required for many
# of the library's functions.
module Gamework
  module App
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
      
      # Use a StringInquirer instance for pretty equality
      # testing, eg Gamework::App.env.test?
      def env
        # Look for a GAMEWORK_ENV constant
        _env = Object.const_defined?('GAMEWORK_ENV') && GAMEWORK_ENV
        # otherwise default to 'development'
        @env ||= ActiveSupport::StringInquirer.new(_env || 'development')
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
      # the main game loop with the first
      # scene as the argument.
      def start!(scene)
        raise "The game has already started." if showing?

        Gamework::ENV ||= 'development'
        make_logger(@log_file)
        @logger.info 'Starting the game'

        make_window
        add_scene(scene)
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

      # End the current scene and
      # load another into the array
      def next_scene(scene)
        end_current_scene
        add_scene(scene)
      end

      # Converts a string into a scene class
      def string_to_scene_class(string)
        base = string.titleize.gsub(' ', '')
        "#{base}Scene".constantize
      end

      def raise_config_error
        raise "Can't set configuration settings after the game has started."
      end

      %w(width height fullscreen title log_file debug).each do |meth|
        define_method "#{meth}=" do |val|
          raise_config_error if showing?
          instance_variable_set "@#{meth}", val
        end
      end

      def caption=(val)
        @caption = val
        window && window.caption = val
      end

      def debug_mode?
        !!@debug
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
