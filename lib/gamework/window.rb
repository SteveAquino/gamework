require 'gosu'

module Gamework
  class Window < Gosu::Window
    # Delegates the basic Gosu::Window interactions
    # to Gamework::App

    def initialize(width, height, fullscreen=false, update_interval=16.666666)
      super(width, height, fullscreen, update_interval)
    end

    def update
      # Called 60 times per second from
      # Gosu::Window class, called before draw
      
      Gamework::App.update
    end

    def draw
      # Called 60 times per second from
      # Gosu::Window class, called after update

      Gamework::App.draw
    end
    
    def button_down(id)
      # Listens to input on the window

      Gamework::App.button_down(id)
    end
    
    def button_up(id)
      # Listens to input on the window

      Gamework::App.button_up(id)
    end
  end
end