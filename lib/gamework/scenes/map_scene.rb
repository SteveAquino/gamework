module Gamework
  class MapScene < Gamework::Scene
    # MapScenes are the heart of gameplay for Gamework
    # games.  MapScenes hold the references to the player,
    # NPCs, Animations, and MapEvents

    attr_reader   :width, :height, :camera_x, :camera_y,
                  :animation_handler

    def initialize
      # The scrolling position is relative to the
      # top left corner of the screen.
      @camera_x = @camera_y = 0

      # @animation_handler = AnimationHandler.new
      # @hud = Hud.new(@player)

      # Mark self as observer to watch for
      # important changes to the player
      # @player.add_observer(self, :observe)
    end

    def update
    #   @player.update
    #   Npc.update
    #   Event.update
    #   @hud.update
    #   @animation_handler.update
    #   update_camera(@player)
    end

    def draw
      # Fixed visualizations go here (HUD, ect...)
      # @hud.draw
      # @dialogue.draw unless @dialogue.nil?

      # Objects that scroll with the camera go here
      translate(-@camera_x, -@camera_y) do
        # @player.draw
        # Npc.draw
        # Event.draw
        # @animation_handler.draw
        @tileset.draw if @tileset
      end
    end

    def translate(camera_x, camera_y, &block)
      # Ties into Gosu::Window#translate method to 
      # pan graphics with user movement

      Gamework::App.window.translate(camera_x, camera_y) { yield }
    end

    # def observe(options={})
    #   # Custom observe function that watches various
    #   # objects on the map and allows animations, ect.. 
    #   # to be arbitrarily created and passed up to the
    #   # parent scene

    #   if animation = options[:animation]
    #     @animation_handler.add_to_queue(animation)
    #   end
    # end

    def update_camera(target)
      # Updates the camera to follow a given
      # Actor on the screen

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

    # # Solid at a given pixel position?
    # def solid?(x, y)
    #   y < 0 || @tiles[x / 32][y / 32]
    # end
  end
end