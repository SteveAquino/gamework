module Gamework
  class Sprite
    # Sprites represent animated graphics that
    # usually belong to Actor instances.  They
    # split animations among 4 directions and
    # can show a default graphic when not
    # animating.

    attr_reader :x, :y, :width, :height, :direction, :moving, :animating

    def initialize(x, y, width, height, spritesheet, animated=false)
      @x, @y, @width, @height = x, y, width, height
      @spritesheet = spritesheet
      @frame       = 0
      @speed       = 3
      @moving      = false
      @animated    = animated
      @z           = 1
      @scale       = 2
      @angle       = 0
      @direction   = :down
      @sprites     = {}

      make_sprites
    end

    def update
      update_frame
      update_sprite
    end

    def draw
      # Use draw_rot to use the center as the reference
      # point, allowing the character to walk to edge of
      # the screen.
      
      @sprite.draw_rot(@x, @y, z_index, @angle, 0.5, 0.5, @scale, @scale)
    end

    def update_frame
      # Sets the value of @frame depending on
      # the length of tiles for a given direction.
      # If the sprite isn't animating, the first
      # frame is shown

      if animating?
        # Draw sprite animations in frames at 60 FPS
        i = Gosu::milliseconds / 60 % @sprites[@direction].size - 1
        @frame = i + 1
      else
        # Show the default sprite
        @frame = 0
      end
    end

    def update_sprite
      # Use :down if direciton is fixed
      # (true for unidirecitonal sprites)

      @sprite = @sprites[@direction][@frame]
    end

    def make_sprites
      # Uses Gosu::Image.load_tiles to split an image
      # up into an array, and then splits it into rows
      # to use for 4-directional animation.

      tiles = Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @width, @height, true)
      i     = tiles.length

      if i % 4 == 0
        # Number of tiles is divisible by 4
        split_tiles_by_four(tiles)
      else
        # Make unidirectional sprite
        split_tiles_by_one(tiles)
      end
      # Set starting sprite
      update_sprite
    end

    def split_tiles_by_four(tiles)
      # Makes a hash of sprites that
      # animates in 4 directions

      length = tiles.length/4
      [:down, :left, :right, :up].each_with_index do |dir, x|
        start_i = x * length
        end_i   = start_i + length
        @sprites[dir] = tiles[start_i...end_i]
      end
    end

    def split_tiles_by_one(tiles)
      # Make unidirectional sprite that
      # animates in one direction (down)

      @sprites = {down: tiles}
    end

    def z_index
      # Bases z_index off of three values:
      #
      # 1. Base z for all Sprite instances (1)
      # 2. Modifyable @z attribute that can be changed if needed
      # 3. @y attribute to allow objects to appear behind others

      1 + @z + @y
    end

    def set_position(x, y)
      @x, @y = x, y
    end

    def turn(direction)
      @direction = direction
    end

    def rotate(degrees)
      # Increase the angle by
      # a given degree

      @angle += degrees
    end

    def set_angle(degrees)
      # Set the angle explicitly

      @angle = degrees
    end

    def animating?
      !!@animated
    end

    def animate
      @animated = true
    end

    def freeze
      @animated = false
    end
  end
end