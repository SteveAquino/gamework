module Gamework
  module WrapTrait
    # Wraps objects to the opposite
    # ends of the screen

    def update_wrap
      @x %= Gamework::App.width  - @width/2
      @y %= Gamework::App.height - @height/2
    end

  end
end
