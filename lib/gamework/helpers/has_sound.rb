module Gamework
  module HasSound

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      @@song = nil
      @@asset_directory = "media"

      def load_song(filename, autoplay=true)
        stop_song
        @@song = Gosu::Song.new(asset_path filename)
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

      def play_sound(filename)
        # Saves sound objects into memory after being loaded
        # Note: Will limit to a single instace of a sound file

        @sounds ||= {}
        sound = @sounds[filename] ||= Gosu::Sample.new(asset_path filename)
        sound.play
      end

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

    extend ClassMethods
  end
end