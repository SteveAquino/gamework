module Gamework
	module Sound

    def self.included(base)
      base.extend ClassMethods
    end

	  module ClassMethods
			def load_song(filename, autoplay=true)
				window = Gamework::App.window
				stop_song
				# "media/songs/#{filename}"
				@@song = Gosu::Song.new(filename)
				play_song if autoplay
				return @@song
			end
			
			def play_song
				@@song.play
			end

			def stop_song
				@@song.stop unless @song.nil?
			end

			def current_song
				@@song
			end

			def play_sound(filename)
				# Saves sound objects into memory after being loaded
				# Note: Will limit to a single instace of a sound file

				window = Gamework::App.window
				@sounds ||= {}
				sound = @sounds[filename] ||= Gosu::Sample.new("media/sounds/#{filename}")
				sound.play
			end
	  end

		extend ClassMethods
	end
end