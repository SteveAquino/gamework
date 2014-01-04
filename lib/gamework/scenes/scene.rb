require "active_support/core_ext/string/inflections"

module Gamework
  class Scene
    # A scene can be thought of as the controller part of
    # a Model View Controller framework.  The scene acts
    # as the delegator for drawing graphics, updating
    # actors, playing sounds, and managing state.

    include Gamework::HasAssets
    include Gamework::HasSound
    include Gamework::HasInput

    @scene_file = nil
    attr_reader :tileset, :drawables, :paused

    def initialize
      # The scrolling position is relative to the
      # top left corner of the screen.
      @camera_x  = 0
      @camera_y  = 0
      @paused    = false
      @built     = false
      @drawables = []
    end

    def load_assets
      # Delay building scene until it's
      # the current scene.

      build_scene(scene_file) if scene_file
      start_scene
      @built = true
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
      # Events
      load_assets unless @built

      before_update

      update_input unless paused?
      update_camera(@camera_target) if @camera_target
      update_drawables

      after_update
    end
    
    def draw
      visible_drawables = @drawables.select {|d| inside_viewport?(d) }
      
      # TODO:
      # Events
      # Animations
      # Dialogue windows

      before_draw

      # Fixed visualizations go here (HUD, ect...)
      visible_drawables.select(&:fixed?).map(&:draw)

      draw_relative do
        # Objects that scroll with the camera go here

        visible_drawables.reject(&:fixed?).map(&:draw)
        @tileset.draw if @tileset
      end

      after_draw
    end

    def draw_relative(camera_x=-@camera_x, camera_y=-@camera_y, &block)
      # Ties into Gosu::Window#translate to 
      # pan graphics with camera movement

      Gamework::App.window.translate(camera_x, camera_y) { yield }
    end

    def inside_viewport?(object)
      width  = Gamework::App.width
      height = Gamework::App.height
      (object.x+object.width/2)  >= @camera_x && (object.x-object.width/2)  <= (@camera_x + width) &&
      (object.y+object.height/2) >= @camera_y && (object.y+object.height/2) <= (@camera_y + height)
    end

    def end_scene
      @finished = true
    end

    def ended?
      !!@finished
    end

    def pause
      @paused = true
    end

    def paused?
      !!@paused
    end

    def quit
      # Utility function to abort the game
      
      Gamework::App.quit
    end

    def follow_with_camera(target)
      @camera_target = target
    end

    def update_camera(target)
      # Updates the camera to follow a given
      # Drawable on the screen within the
      # boundaries of the tileset

      half_width  = Gamework::App.center_x
      half_height = Gamework::App.center_y
      
      @camera_x = [
        [target.x - (half_width),  0].max,
        target.width * @tileset.tile_size - half_width
      ].min
      @camera_y = [
        [target.y - (half_height), 0].max,
        target.height * @tileset.tile_size - half_height
      ].min
    end

    def solid_objects
      # Returns all drawables that respond
      # to solid? and return true

      @drawables.select {|d| d.respond_to?(:solid?) && d.solid?}.compact
    end

    def update_drawables
      # Remove objects marked for deletion
      @drawables.delete_if(&:delete?)
      # Fixed objects always get updated
      # Only update unfixed objects inside the viewport
      @drawables.each {|d| d.update if d.fixed? || inside_viewport?(d) }
    end

    # Creation Utility Functions

    def create_tileset(mapfile, *args)
      # Alias for Gamework::Tileset.create

      @tileset = Gamework::Tileset.create(mapfile, *args)
    end

    def create_drawable(options={}, type='drawable')
      # Creates a new drawable instance of a given type

      base = type.titleize.gsub('/','::').gsub(' ', '')
      if Gamework.const_defined?(base) and !Object.const_defined?(base)
        base.prepend("Gamework::")
      end
      class_name = base.constantize
      add_drawable class_name.new(options)
    end

    def show_text(text, options={})
      # Alias for Gamework::Text.new
      
      add_drawable Gamework::Text.new(text, options)
    end

    def show_shape(type, options={})
      # Alias for Gamework::Shape.new

      add_drawable Gamework::Shape.new(type, options)
    end

    def show_animation(options={})
      # Alias for Gamework::Animation.new

      add_drawable Gamework::Animation.new(options)
    end

    def draw_background(options={})
      # Draws a :background type shape
      # below other drawables

      settings = {z: -1, fixed: true}.merge(options)
      show_shape(:background, settings)
    end

    def add_drawable(drawable)
      # Separates drawable objects into
      # fixed and unfixed arrays for
      # drawing relative to the map.

      @drawables << drawable
      return drawable
    end

    def <<(drawable)
      add_drawable drawable
    end

    def delete_drawable(drawable)
      # Removes a drawable object

      @drawables.delete drawable
    end

    def build_scene(scene_file)
      # Create the scene from a given yaml file

      builder = Gamework::SceneBuilder.new(self, scene_file)
      builder.load
      builder.build_scene
      return self
    end

    def self.build_scene(scene_file)
      # Sets a class instance variable that
      # tells new instances to build from
      # this file after initializing

      filename = File.expand_path(scene_file)
      @scene_file = filename
    end

    private

    def scene_file
      self.class.instance_variable_get "@scene_file"
    end
  end
end