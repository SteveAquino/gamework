module Gamework
	module App
		# The Gamework::App module manages opening and closing the
		# game window.  There is only ever one instance of Gamework::Window
		# that is accessible elsewhere in the app by calling
		# Gamework::App.window

		# include sound managing API for convenience
		include Gamework::Sound

		class << self
			@showing = false

			def window
				# Returns the only instance of Gosu::Window so
				# it is available to the rest of the app by
				# calling Gamework::App.window
				@window
			end

			def make_window
				@window ||= Gamework::Window.new
			end

			def show
				@showing = true
				@window.show
			end

			def showing?
				@showing
			end

			def start
				return if showing?
				make_window and show
			end

			def exit
				@showing = false
				@window.close
			end
		end

	end
end