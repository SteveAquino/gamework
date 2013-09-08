module Gamework
  module AnimatedSpriteTrait
    # Creates an array of sprites
    # from a given graphic.

    def initialize_animated_sprite
      @frame         ||= 0
      @animated      ||= false
      @animating     ||= false
      @split_sprites ||= false
    end

    def update_animated_sprite
      # Lazy load sprites
      make_sprites if @sprites.nil?
      update_frame
      update_sprite
    end

    def draw_animated_sprite
      return if @sprite.nil?
      # Use draw_rot to use the center for reference
      @sprite.draw_rot(@x, @y, z_index, @angle, 0.5, 0.5, @scale, @scale)
    end

    def update_frame
      # Sets the value of @frame depending on
      # the length of tiles for a given direction.
      # If the sprite isn't animating, the first
      # frame is shown

      if animating?
        # Draw sprite animations in frames at 60 FPS
        i = Gosu::milliseconds / 60 % sprite_collection.size - 1
        @frame = i + 1
      else
        # Show the default sprite
        @frame = 0
      end
    end

    def update_sprite
      @sprite = sprite_collection[@frame]
    end

    def sprite_collection
      # Detects direction for directional
      # sprites or a normal array

      if @sprites.kind_of?(Hash)
        @sprites[@direction]
      else
        @sprites
      end
    end

    def make_sprites
      # Uses Gosu::Image.load_tiles to split an image
      # up into an array, and then splits it into rows
      # to use for 4-directional animation.

      tiles = Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @width, @height, true)

      if @split_sprites
        split_tiles_by_four(tiles)
      else
        @sprites = tiles
      end
    end

    def split_tiles_by_four(tiles)
      # Makes a hash of sprites that
      # animates in 4 directions

      @sprites = {}
      length = tiles.length/4
      [:down, :left, :right, :up].each_with_index do |dir, x|
        start_i = x * length
        end_i   = start_i + length
        @sprites[dir] = tiles[start_i...end_i]
      end
    end

    def z_index
      # Bases z_index off of three values:
      #
      # 1. Base z for all sprites (1)
      # 2. Modifyable @z attribute that can be changed if needed
      # 3. @y attribute to allow objects to appear behind others

      1 + @z + @y
    end

    def animating?
      !!@animated || !!@animating
    end

    def animate
      @animating = true
    end

    def freeze
      @animating = false
    end

  end
end