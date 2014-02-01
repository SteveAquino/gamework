require 'yaml'
require "active_support/core_ext/hash"

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
      @data = YAML.load(file).with_indifferent_access
      file.close
      # Return the data loaded
      @data
    end
    
    def build_scene
      @data.each do |type, data|
        if type == "song"
          build_song data.symbolize_keys
        elsif type == "tileset"
          build_tileset data.symbolize_keys
        elsif data.kind_of?(Array)
          data.each {|d| build_drawable(type, d.symbolize_keys) }
        else
          build_drawable type, data.symbolize_keys
        end
      end
    end

    def build_song(data)
      @scene.load_song asset_path(data[:songfile]), data[:autoplay]
    end

    def build_tileset(data)
      data[:mapfile]     = asset_path(data[:mapfile])
      data[:spritesheet] = asset_path(data[:spritesheet])
      @scene.create_tileset *data.values
    end

    def build_drawable(type, data)
      name = data.delete(:name)
      data[:spritesheet] = asset_path(data[:spritesheet]) if data[:spritesheet]
      drawable = @scene.create_drawable(data, type)
      @scene.follow(drawable) if data[:follow]
      @scene.instance_variable_set "@#{name}", drawable if name
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