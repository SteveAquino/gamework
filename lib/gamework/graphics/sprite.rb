module Gamework
  class Sprite
    # SpriteSheets represent animated graphics that
    # usually belong to Actor instances.

    attr_reader :x, :y, :width, :height, :direction, :moving, :animating

    def initialize(x, y, width, height, spritesheet)
      @x, @y, @width, @height = x, y, width, height
      @spritesheet = spritesheet
      @frame       = 0
      @speed       = 3
      @moving      = false
      @z           = 1
      @direction   = :down
      @sprites     = {}

      make_sprites
    end

    def draw
      # Hide sprite when the animating
      return if @animating
      @sprite.draw_rot(@x, @y, z_index, 0, 0.5, 0.5, 2, 2)
    end

    def update
      update_frame
      update_sprite
    end

    def update_frame
      # Sets the value of @frame depending on
      # the length of tiles for a given direction.
      # If the sprite isn't animating, the first
      # frame is shown

      if @moving
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

      tiles = Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @width, @height, false)
      i     = tiles.length

      if i % 4 == 0
        # Number of tiles is divisible by 4
        split_tiles_by_four(tiles)
      else
        # Make unidirectional sprite
        split_tiles_by_one(tiles)
      end
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

    def move(direction)
      turn direction unless @dir_fixed
      # return if obstructed?(direction)
      
      case direction
      when :up
        @y -= @speed
      when :left
        @x -= @speed
      when :down
        @y += @speed
      when :right
        @x += @speed
      end
      @moving = true
    end

    def step_forward
      move @direction
    end

    def stop
      @moving = false
    end
  end
end