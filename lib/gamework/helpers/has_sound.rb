module Gamework
  module HasSound
    # Allows objects to easily interact with the
    # Gosu::Sample and Gosu::Song API.

    # Hold a single reference to a song since
    # only one song can play at a time.
    @@song = nil

    def load_song(file, autoplay=true)
      stop_song
      @@song = Gosu::Song.new(file)
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
      sound = @sounds[id] ||= Gosu::Sample.new(file)
      sound.play
    end

  end
end