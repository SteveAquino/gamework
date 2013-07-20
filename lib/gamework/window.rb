require 'gosu'

module Gamework
	class Window < Gosu::Window
		# TODO: Allow optional setting of view_mode to be
		# either :isometric (top-down) or :platform (horizontal)


		def initialize(width, height, fullscreen=false, update_interval=16.666666)
			super(width, height, fullscreen, update_interval)
			self.caption = "This is a Gamework Game!"
		end

		def update
			# Called 60 times per second from
			# Gosu::Window class

			Scene.update
		end

		def draw
			Scene.draw
	    
			if Gamework::App.debug_mode? && button_down?(Gosu::Button::KbTab)
				self.caption = [Gamework::App.title, "(#{Gosu.fps} fps), #{time}"].compact.join(" ")
			else
				self.caption = Gamework::App.title
			end
		end
		
		def button_down(id)
			Scene.button_down(id)
		end

		def time
			t = Time.now.localtime
			t.strftime("%r")
		end
	end
end