module Gamework
  module Sound
    # Allows objects to easily interact with the
    # Gosu::Sample and Gosu::Song API.

    @@song = nil
    @@asset_directory = "assets"

    def load_song(file, autoplay=true)
      stop_song
      @@song = Gosu::Song.new(asset_path file)
      play_song if autoplay
      return @@song
    end
    
    def play_song(file)
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

    # TODO: Move asset methods into another module
    def asset_directory
      @@asset_directory
    end

    def asset_directory=(path)
      @@asset_directory = path
    end

    def asset_path(file=nil, *args)
      # Allows you to passing multiple arguments to build a file path
      # relative to the asset_directory.

      base_path = [asset_directory, args.reverse].compact.join('/')
      File.expand_path(file, base_path)
    end
  end
end