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
    attr_reader :tileset, :actors, :paused

    def initialize
      # The scrolling position is relative to the
      # top left corner of the screen.
      @camera_x  = 0
      @camera_y  = 0
      @paused    = false
      @built     = false
      @actors = []
    end

    # Delay building scene until it's
    # the current scene.
    def _start_scene
      # Load YAML file
      build_scene(scene_file) if scene_file
      # Call hook method
      start_scene
      # Perform opening transition
      do_transition(transition_options[:start]) if transition_options.try(:[], :start)
      # Mark self as built
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
      # Lazy load scene
      _start_scene unless @built

      before_update

      update_input
      update_camera(@camera_target) if @camera_target
      update_actors

      after_update
    end
    
    def draw
      # Optimize visual calculations by only
      # drawing options inside the viewport
      visible_actors = @actors.select {|d| inside_viewport?(d) }
      
      before_draw

      # Fixed visualizations go here (HUD, ect...)
      visible_actors.select(&:fixed?).map(&:draw)

      # Objects that scroll with the camera go here
      draw_relative do
        visible_actors.reject(&:fixed?).map(&:draw)
        @tileset.draw if @tileset
      end

      after_draw
    end

    # Ties into Gosu::Window#translate to 
    # pan graphics with camera movement
    def draw_relative(camera_x=-@camera_x, camera_y=-@camera_y, &block)
      Gamework::App.window.translate(camera_x, camera_y) { yield }
    end

    def inside_viewport?(object)
      width  = Gamework::App.width
      height = Gamework::App.height
      (object.x+object.width/2)  >= @camera_x && (object.x-object.width/2)  <= (@camera_x + width) &&
      (object.y+object.height/2) >= @camera_y && (object.y+object.height/2) <= (@camera_y + height)
    end

    def end_scene
      return false if @finished
      do_transition(transition_options[:end]) if transition_options.try(:[], :end)
      @finished = true
    end

    # Returns true if the scene is marked
    # as ended and there are no current
    # transitions
    def ended?
      !!@finished && !transition?
    end

    # Returns true if there is a transition
    # that still hasn't finished yet
    def transition?
      not @transition.nil? || @transition.finished?
    end

    def pause
      @paused = true
    end

    def paused?
      !!@paused
    end

    # Utility function to abort the game
    def quit
      Gamework::App.quit
    end

    # Sets the camera target to a given
    # object to track it with the camera
    def follow(target)
      @camera_target = target
    end

    # Stop following any targets with
    # the camera
    def unfollow
      @camera_target = nil
    end

    # Updates the camera to follow a given
    # actor on the screen within the
    # boundaries of the tileset
    def update_camera(target)
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
      # Returns all actors that respond
      # to solid? and return true

      @actors.select {|d| d.respond_to?(:solid?) && d.solid?}.compact
    end

    def update_actors
      # Remove objects marked for deletion
      @actors.delete_if(&:delete?)
      # Fixed objects always get updated
      # Only update unfixed objects inside the viewport
      @actors.each {|d| d.update if d.fixed? || inside_viewport?(d) }
    end

    # Creation Utility Functions

    # Alias for Gamework::Tileset.create
    def create_tileset(mapfile, *args)
      @tileset = Gamework::Tileset.create(mapfile, *args)
    end

    # Creates a new actor instance of a given type
    # and adds it to the collection
    def create_actor(options={}, type='actor')
      name = type.titleize.gsub('/', '::').gsub(' ', '')
      base = name.split('::').first.intern

      name.prepend("Gamework::") if Gamework.constants.include? base
      name += "::Base" if name.constantize.constants.include? :Base

      klass = name.constantize
      add_actor klass.new(options)
    end

    # Adds a new Gamework::Text to the collection
    def show_text(text, options={})
      add_actor Gamework::Text.new(text, options)
    end

    # Adds a new Gamework::Shape to the collection
    def show_shape(type, options={})
      add_actor Gamework::Shape.new(type, options)
    end

    # Adds a new Gamework::Animation to the collection
    def show_animation(options={})
      add_actor Gamework::Animation.new(options)
    end

    # Draws a :background type shape
    # below other actors
    def draw_background(options={})
      settings = {z: -1, fixed: true}.merge(options)
      show_shape(:background, settings)
    end

    # Adds a actor to the collection
    def add_actor(actor)
      @actors << actor
      return actor
    end

    def <<(actor)
      add_actor actor
    end

    # Removes a actor object
    def delete_actor(actor)
      @actors.delete actor
    end

    # Create the scene from a given yaml file
    def build_scene(scene_file)
      builder = Gamework::SceneBuilder.new(self, scene_file)
      builder.load
      builder.build_scene
      return self
    end

    # Create new transition instance attached to the scene
    def do_transition(options)
      type = options.delete(:type)
      @transition = add_actor Gamework::Transition.new(type, options)
    end

    class << self

      # Sets a class instance variable that
      # tells new instances to build from
      # this file after initializing
      def build_scene(scene_file)
        filename = File.expand_path(scene_file)
        @scene_file = filename
      end

      # Sets a class instance variable that
      # tells new instances to how to
      # transition into and out of a scene
      def transition(options={})
        _all   = options.delete(:nil)
        _start = _all || options.delete(:start)
        _end   = _all || options.delete(:end)

        @transition_options ||= { }
        @transition_options[:start] = {type: _start}.merge(options) if _start
        @transition_options[:end]   = {type: _end}.merge(options) if _end
      end
    end

    private

    def scene_file
      self.class.instance_variable_get "@scene_file"
    end

    def transition_options
      self.class.instance_variable_get "@transition_options"
    end
  end
end
