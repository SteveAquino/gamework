require 'gosu'

# Delegates the basic Gosu::Window interactions
# to Gamework::App
module Gamework
  class Window < Gosu::Window
    def initialize(width, height, fullscreen=false, update_interval=16.666666)
      super(width, height, fullscreen, update_interval)
    end

    # Called 60 times per second from
    # Gosu::Window class, called before draw
    def update
      Gamework::App.update
    end

    # Called 60 times per second from
    # Gosu::Window class, called after update
    def draw
      Gamework::App.draw
    end
    
    # Listens to input on the window, called
    # when a key or button is pressed
    def button_down(id)
      Gamework::App.button_down(id)
    end
    
    # Listens to input on the window, called
    # when a key or button is released
    def button_up(id)
      Gamework::App.button_up(id)
    end
  end
end
