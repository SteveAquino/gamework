require 'rubygems'
require 'gamework'
require 'pry'

puts "Running Gamework Version #{Gamework::VERSION}"

class StartScene < Gamework::Scene
  on_button_down 'return', 'kb', :end_scene

  def start_scene
    x = Gamework::App.center_x
    @triangles = [
      Gamework::Shape.new(:triangle, x: x+50, y: 300, size: 100, color: 'yellow'),
      Gamework::Shape.new(:triangle, x: x-50, y: 300, size: 100, color: 'yellow'),
      Gamework::Shape.new(:triangle, x: x, y: 200, size: 100, color: 'yellow')
    ]
    show_text :title, "Example Game", x: 250, y: 50, size: 50
    show_text :menu, "Press ENTER to Start", x: 310, y: 500, size: 20
  end

  def before_draw
    @triangles.each {|t| t.draw}
  end
end

class CoolScene < Gamework::Scene
  # Load scene from yaml file
  build_scene "examples/advanced_map.yaml"
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player

  def move_player(dir)
    player.move(dir.intern)
  end

  def stop_player(dir=nil)
    player.stop
  end
  
  def player
    @actors[:player]
  end
end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Advanced Example"
  # c.debug_mode = true
end

Gamework::App.start do
  Gamework::App << StartScene
  Gamework::App << CoolScene
end