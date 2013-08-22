module Gamework
  class Composite < Gamework::Drawable
    # Represents a nestable tree of elements
    # that can be drawn.  Allows objects to
    # be positioned relative to each other.

    attr_reader :drawables, :fixed

    def draw
      @drawables.each {|d| d.draw}
    end

    def update
      @drawables.each {|d| d.update}
    end

    def fix
      @drawables.each {|d| d.fix}
    end

    def unfix
      @drawables.each {|d| d.unfix}
    end

    def fixed?
      !!@fixed
    end

  end
end