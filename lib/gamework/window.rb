require 'gosu'

module Gamework
	class Window < Gosu::Window
		# TODO: Allow optional setting of view_mode to be
		# either :isometric (top-down) or :platform (horizontal)

		Width  = 1000
		Height = 1000
		# Center = [(Width/2), (Height/2)]

		def initialize
			super Width, Height, false
			self.caption = "This is a Gamework Game!"
		end

		def update
			# Called 60 times per second from
			# Gosu::Window class

			# Scene.current.update
		end

		def draw
			# Scene.current.draw
	      
			# if button_down? Gosu::Button::KbTab
			# 	self.caption = "#{Title} (#{Gosu.fps} fps), #{time}"
			# else
			# 	self.caption = Title
			# end
		end

		def show
			# Calls Gosu::Window#show which opens
			# the game window and begins the
			# input/output loop
			super
		end
		
		def button_down(id)
			# Scene.current.button_down(id)
		end

		# def time
		# 	t = Time.now.localtime
		# 	t.strftime("%r")
		# end
	end
end