module Gamework
  module App
    # The Gamework::App module manages opening and closing the
    # game window.  There is only ever one instance of Gamework::Window
    # that is accessible elsewhere in the app by calling
    # Gamework::App.window

    @@scenes = []

    class << self
      # Class Methods (accessible via Gamework::App#method)

      @showing = false
      attr_accessor :width, :height, :fullscreen, :debug_mode, :title

      def update
        # Updates the current Scene instance
        # at the front of the collection

        # First check for and remove the current Scene
        # if it's marked for deletion
        @@scenes.shift if current_scene and current_scene.ended?

      	unless current_scene.nil?
          current_scene.update
        else
          exit
        end
      end

      def draw
				current_scene and current_scene.draw
      end

      def button_down(id)
        current_scene and current_scene.button_down(id)
      end

      def button_up(id)
        current_scene and current_scene.button_up(id)
      end

      def window
        # Returns the only instance of Gosu::Window so
        # it is available to the rest of the app by
        # calling Gamework::App.window

        @window
      end

      def make_window
        @window ||= Gamework::Window.new(@width, @height, !!@fullscreen)
      end

      def show
        # Calls Gosu::Window#show which opens
        # the game window and begins the loop

        @showing = true
        @window.show
      end

      def showing?
        @showing
      end

      def start(&block)
      	# Creates a new window, runs an
      	# optional block, and then begins
      	# the main game loop

        return if showing?
        make_window
        yield if block_given?
        show
      end

      def exit
        @showing = false
        @window.close
      end

      def quit
        # Empties the scene collection to
        # allow the game and current scene
        # to close on the next update

        scene = current_scene
        scene.end_scene
        @@scenes = [scene]
      end

      def config(&block)
        # Allow block style configuration settings, ie:
        #
        # config.do |c|
        #   c.width  = 800
        #   c.height = 640
        # end

        # Raise error if the window is already drawn
        raise_config_error if showing?
        yield(Gamework::App)
      end

      def current_scene
      	@@scenes.first
      end

      def add_scene(scene)
      	unless scene <= Gamework::Scene
	      	raise "Must be type of Gamework::Scene or subclass"
	      end
        @@scenes.push(scene.new)
      end

      def <<(scene)
        add_scene(scene)
      end

      def end_current_scene
    		current_scene.end_scene
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

      def debug_mode?
        !!@debug
      end

      def debug_mode=(val)
        raise_config_error if showing?
        @debug_mode = val
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