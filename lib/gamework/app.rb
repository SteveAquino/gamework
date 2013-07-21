module Gamework
  module App
    # The Gamework::App module manages opening and closing the
    # game window.  There is only ever one instance of Gamework::Window
    # that is accessible elsewhere in the app by calling
    # Gamework::App.window

    # include sound managing API for convenience
    include Gamework::Sound

    class << self
      # Class Methods (accessible via Gamework::App#method)

      @showing = false
      attr_accessor :width, :height, :fullscreen, :debug_mode, :title

      def window
        # Returns the only instance of Gosu::Window so
        # it is available to the rest of the app by
        # calling Gamework::App.window

        @window
      end

      def make_window
        @window ||= Gamework::Window.new(width, height, fullscreen)
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
        return if showing?
        make_window
        yield if block_given?
        show
      end

      def exit
        @showing = false
        @window.close
      end

      def config(&block)
        # Allow block style configuration settings,
        # ie: 
        # config.do |c|
        #   c.width  = 800
        #   c.height = 640
        # end

        # Raise error if the window is already drawn
        if showing?
          raise RuntimeError, "Can't set configuration settings after Gamework::Window#show draws the window."          
        end

        yield(Gamework::App)
      end

      # Define class level accessor methods for
      # easy configuration settings, but raise
      # error if the window is already drawn

      def width=(val)
        if showing?
          raise RuntimeError, "Can't set configuration settings after Gamework::Window#show draws the window."
        end
        @width = val
      end

      def height=(val)
        if showing?
          raise RuntimeError, "Can't set configuration settings after Gamework::Window#show draws the window."
        end
        @height = val
      end

      def fullscreen=(val)
        if showing?
          raise RuntimeError, "Can't set configuration settings after Gamework::Window#show draws the window."
        end
        @fullscreen = val
      end

      def debug_mode?
        !!@debug
      end

      def debug_mode=(val)
        if showing?
          raise RuntimeError, "Can't set configuration settings after Gamework::Window#show draws the window."
        end
        @debug_mode = val
      end

      def center
        [(@width/2), (@height/2)]
      end
    end

  end
end