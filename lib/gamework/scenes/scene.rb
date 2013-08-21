module Gamework
  class Scene
    # A scene can be thought of as the controller part of
    # a Model View Controller framework.  The scene acts
    # as the delegator for drawing graphics, updating
    # actors, playing sounds, and managing state.

    include Gamework::HasAssets
    include Gamework::HasSound
    include Gamework::HasInput
    include Gamework::HasShapes

    @scene_file = nil
    attr_reader :tileset, :actors, :paused

    def initialize
      # The scrolling position is relative to the
      # top left corner of the screen.
      @camera_x = @camera_y = 0

      @paused = false
      @actors = {}
      @text   = {}
      # @windows = {}

      build_scene(scene_file) if scene_file
      start_scene
    end

    # Define hook methods to allow flexible
    # control of game flow.
    def start_scene; end
    def close_scene; end

    def before_update; end
    def after_update; end

    def before_draw; end
    def after_draw; end

    def update
      # TODO:
      # HUD
      # Events
      # Animations

      before_update

      update_input unless paused?
      update_camera(@camera_target) if @camera_target
      update_actors

      after_update
    end
    
    def draw
      # TODO:
      # HUD
      # Events
      # Animations
      # Text
      # Dialogue windows

      # Fixed visualizations go here (HUD, ect...)
      before_draw

      @text.values.each {|t| t.draw }
      draw_relative do
        # Objects that scroll with the camera go here

        @actors.values.each {|a| a.draw }
        @tileset.draw if @tileset
      end

      after_draw
    end

    def draw_relative(camera_x=-@camera_x, camera_y=-@camera_y, &block)
      # Ties into Gosu::Window#translate to 
      # pan graphics with camera movement

      Gamework::App.window.translate(camera_x, camera_y) { yield }
    end

    def end_scene
      @end_scene = true
    end

    def ended?
      !!@end_scene
    end

    def pause
      @paused = true
    end

    def paused?
      !!@paused
    end

    def follow_with_camera(target)
      @camera_target = target
    end

    def update_camera(target)
      # Updates the camera to follow a given
      # Actor on the screen within the
      # boundaries of the tileset

      half_width  = Gamework::App.center_x
      half_height = Gamework::App.center_y
      
      @camera_x = [
        [target.x - (half_width),  0].max,
        target.width * @tileset.tile_width - half_width
      ].min
      @camera_y = [
        [target.y - (half_height), 0].max,
        target.height * @tileset.tile_height - half_height
      ].min
    end

    def update_actors
      @actors.values.each {|a| a.update }
    end

    def create_tileset(mapfile, *args)
      # Alias for Gamework::Tileset.create

      @tileset = Gamework::Tileset.create(mapfile, *args)
    end

    def create_actor(id, options={})
      # Alias for Gamework::Actor.create

      actor = Gamework::Actor.create(options)
      @actors[id] = actor
      if options[:follow]
        follow_with_camera(actor)
      end
      return actor
    end

    def create_actors(actors={})
      # Create many actors from a hash

      actors.each {|id, options| create_actor(id, options)}
      return @actors
    end

    def show_text(id, text, options={})
      # Alias for Gamework::Text.new
      
      @text[id] = Gamework::Text.new(text, options)
    end

    def build_scene(scene_file)
      # Create the scene from a given yaml file

      builder = Gamework::SceneBuilder.new(self, scene_file)
      builder.load
      builder.build_scene
      self
    end

    def self.build_scene(scene_file)
      # Sets a class instance variable that
      # tells new instances to build from
      # this file after initializing

      filename = File.expand_path(scene_file)
      @scene_file = filename
    end

    # def draw_window(id, *args)
    #   @windows[id] = GameWindow.new(*args)
    # end

    private

    def scene_file
      self.class.instance_variable_get "@scene_file"
    end
  end
end