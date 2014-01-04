module Gamework
  class Animation < Gamework::Drawable

    def initialize(options={})
      defaults = {
        z:      1000,
        repeat: false,
        speed:  4,
        frame:  0
      }
      super(defaults.merge options)
    end

    def update
      if @sprites.nil?
        # Lazy load sprites
        make_sprites(@spritesheet)
        trim_sprites
      end
      update_sprites
    end

    def trim_sprites
      # Allows the same image to be used
      # for multiple animations

      @offset ||= 0
      @cutoff ||= @sprites.size
      @sprites  = @sprites.slice(@offset, @cutoff)
    end

    def draw
      draw_sprite
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

      i = Gosu::milliseconds / 60 % @sprites.size - 1
      @frame = i
    end

  end
end