module Gamework
  class Drawable
    # Represents objects within a scene
    # that need to respond to update and
    # draw on each frame.

    attr_reader :fixed

    def draw; end
    def update; end

    def fix
      @fixed = true
    end

    def unfix
      @fixed = false
    end

    def fixed?
      # If this method returns true, the
      # object will be drawn fixed on the
      # screen and move with the camera.
      # The default is to scroll with the
      # map as the camera moves.

      !!@fixed
    end
  end
end