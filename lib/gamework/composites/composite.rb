# Represents a nestable tree of elements
# that can be drawn.  Extend this class
# when you need mutliple objects to be
# positioned relative to each other.

module Gamework
  class Composite < Gamework::Drawable
    attr_reader :drawables, :fixed

    def initialize(options={})
      @drawables = []
      super(options)
    end

    def draw
      @drawables.each {|d| d.draw}
    end

    def update
      @drawables.each {|d| d.update}
    end

    def add_drawable(drawable)
      @drawables << drawable
    end

    def <<(drawable)
      add_drawable(drawable)
    end

    def delete_drawable(drawable)
      @drawables.delete(drawable)
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