module Gamework
  class Transition < Gamework::Actor::Base
    def initialize(type, options={})
      @type     = type
      @finished = false
      defaults  = {
        z: 9999,
        fixed: true,
        duration: 1,
        color: 'black'
      }
      super(defaults.merge options)
      make_surface(@type)
    end

    def draw
      @surface.draw
    end

    def update
      update_surface(@type, @duration)
      delete if finished?
    end

    # Create an instance of Gamework::Drawable
    # to use for making transition effects
    def make_surface(type)
      @surface = case type.intern
      when :fade_in
        Gamework::Shape.new(:background, {z: @z, fixed: true, color: @color})
      when :fade_out
        Gamework::Shape.new(:background, {z: @z, fixed: true, color: @color, alpha: 0})
      end
    end
  
    def update_surface(type, duration)
      case type.intern
      when :fade_in
        fade_in(duration)
      when :fade_out
        fade_out(duration)
      end
    end

    # Decrease the surface alpha over a
    # given duration
    def fade_in(duration)
      delta = (255/60/duration.to_f).round
      @surface.fade(delta)
      @finished = @surface.alpha == 0
    end

    # Increase the surface alpha over a
    # given duration
    def fade_out(duration)
      delta = (255/60/duration.to_f).round
      @surface.fade(delta * -1)
      @finished = @surface.alpha == 255
    end

    # A boolean flag that causes the transition
    # to call delete on itself on the next update
    def finished?
      !!@finished
    end
  end
end
