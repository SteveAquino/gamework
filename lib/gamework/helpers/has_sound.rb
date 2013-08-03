module Gamework
  module HasSound
    # Allows objects to easily interact with the
    # Gosu::Sample and Gosu::Song API.

    @@song = nil

    def load_song(file, autoplay=true)
      stop_song
      @@song = Gosu::Song.new(asset_path file)
      play_song if autoplay
      return @@song
    end
    
    def play_song
      @@song.play unless @@song.nil?
    end

    def stop_song
      @@song.stop unless @@song.nil?
    end

    def current_song
      @@song
    end

    def play_sound(id, file)
      # Caches sound objects into memory after being loaded
      # Different classes that include this module will
      # have their own caches for sounds

      @sounds ||= {}
      sound = @sounds[id] ||= Gosu::Sample.new(asset_path file)
      sound.play
    end

  end
end