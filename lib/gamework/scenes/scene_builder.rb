require 'yaml'

module Gamework
  class SceneBuilder
    # A SceneBuilder instance loads data
    # from a data file and prepares a scene
    # instance with that data.  The Scene
    # yaml files can be thought of as the
    # View part of a Model View Controller
    # framework.

    attr_reader :scene, :filename

    def initialize(scene, filename)
      @scene    = scene
      @filename = filename
    end

    def load
      file  = File.open(@filename, 'r')
      @data = YAML.load(file)
    end
    
    def build_scene
      build_song
      build_actors
      build_tileset
    end

    def build_song
      data = @data["song"]
      return if data.nil?
      @scene.load_song asset_path(data["songfile"]), data["autoplay"]
    end

    def build_actors
      data = @data["actors"]
      return if data.nil?
      data.each do |id, args|
        args["spritesheet"] = asset_path(args["spritesheet"])
        @scene.create_actor id.intern, args
      end
    end

    def build_tileset
      data = @data["tileset"]
      return if data.nil?
      data["mapfile"] = asset_path(data["mapfile"])
      data["spritesheet"] = asset_path(data["spritesheet"])
      @scene.create_tileset *data.values
    end

    def asset_path(path)
      if @scene.respond_to?(:asset_path)
        @scene.asset_path(path)
      else
        path
      end
    end

    def export
      # json     = TextImage.export_json
      # filename = File.expand_path('text_images.yaml', 'db/redesign')
      # file     = File.open(filename, 'w')
      # YAML.dump(json, file)
    end
  end
end