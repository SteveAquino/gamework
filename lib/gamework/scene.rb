module Gamework
	class Scene
		# A scene can be thought of as the controller part of
		# a Model View Controller framework.  The scene acts
		# as the delegator for drawing graphics, updating
		# objects, playing sounds, and managing state.

		include Gamework::Collection
 
		attr_reader :song

		def initialize
			@windows = {}
			@text    = {}
		end

		def update
			# Updates the current Scene instance
			# at the front of the collection
			
			first.update unless first.nil?
		end
		
		def draw
			@windows.values.each {|window| window.draw}
			@text.values.each do |text_options|
				font = text_options[:font_object]	
				font.draw(text_options[:text],  text_options[:x],        text_options[:y],
							    text_options[:z],     text_options[:factor_x], text_options[:factor_y],
				          text_options[:color], text_options[:mode])
			end
		end
		
		def button_down(id)
		end

		def load_song(filename, autoplay=true)
			@song.stop unless @song.nil?
			@song = Gosu::Song.new($game, "media/songs/#{filename}")
			@song.play if autoplay
		end

		def play_sound(filename)
			# Saves sound objects into memory after being loaded
			# Note: Will limit a single instace of a sound per scene
			@sounds ||= {}
			sound = @sounds[filename] ||= Gosu::Sample.new($game, "media/sounds/#{filename}")
			sound.play
		end

		def draw_window(id, *args)
			@windows[id] = GameWindow.new(*args)
		end

		def draw_text(id, text, options={}, font_options={})
			options[:x]           ||= 0
			options[:y]           ||= 0
			options[:z]           ||= ZOrder::Text
			options[:factor_x]    ||= 1
			options[:factor_y]    ||= 1
			options[:color]       ||= Colors::Default
			options[:mode]				||= :default
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

		def next_scene(scene)
			# TODO: Allow passing of symbol and convert to class name
			Scene.next!(scene.new)
		end

		def end_scene
			@@scenes.shift
		end

		# Class Methods
		class << self
			def next!(scene=nil)
				scene.new if scene
				shift
			end

			def find(klass)
				klass = klass.to_s.downcase.intern
				select {|s| klass == s.class.to_s.downcase.intern }
			end
		end
	end
end