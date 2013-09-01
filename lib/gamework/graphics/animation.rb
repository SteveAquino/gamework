module Gamework
  class Animation < Gamework::Drawable
    # Uses an array of images to
    # create animations

    def initialize(spritesheet, options={})
      @spritesheet = spritesheet
      defaults = {
        x: 0, y: 0, z: 1000,
        width:    options[:size]||30,
        height:   options[:size]||30,
        animated: false,
        fixed:    false,
        repeat:   false,
        scale:    2,
        speed:    4,
        frame:    0
      }
      if (pos = options.delete :position)
        options[:x] = pos[0]
        options[:y] = pos[1]
      end
      set_options(defaults.merge options)
      make_sprites
    end

    def make_sprites
      # Uses Gosu::Image.load_tiles to split an image
      # up into an array of images used as frames

      @sprites = Gosu::Image.load_tiles(Gamework::App.window, @spritesheet, @width, @height, true)
      @offset ||= 0
      @cutoff ||= @sprites.size
      @sprites = @sprites.slice(@offset, @cutoff)
    end

    def update
      update_sprite
      update_frame
    end

    def update_frame
      if @repeat
        # Loops frames until explicitly stopped
        loop_frames
      else
        # Increments through the animation once
        increment_frame
      end
    end

    def increment_frame
      # Increment the frame from start to end

      @t ||= 0
      @t += 1/@speed.to_f
      @frame = @t.round
      delete if @frame == @sprites.size
    end

    def loop_frames
      # Loops frames infinitly using modulo

      rate = @speed * 10
      i = Gosu::milliseconds / 60 % @sprites.size - 1
      @frame = i
    end

    def update_sprite
      # Use :down if direciton is fixed
      # (true for unidirecitonal sprites)

      @sprite = @sprites[@frame]
    end

    def draw
      # Use draw_rot to use the center as the reference
      # point, allowing the character to walk to edge of
      # the screen.
      
      @sprite.draw_rot(@x, @y, @z, 0, 0.5, 0.5, @scale, @scale)
    end

    def split_tiles_by_four(tiles)
      # Makes a hash of sprites that
      # animates in 4 directions

      length = tiles.length/4
      4.times do |x|
        start_i = x * length
        end_i   = start_i + length
        @sprites[dir] = tiles[start_i...end_i]
      end
    end
  end
end