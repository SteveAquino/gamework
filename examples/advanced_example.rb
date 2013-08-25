require 'rubygems'
require 'gamework'
require 'pry'

class StartScene < Gamework::Scene
  on_button_down 'return', 'kb', :end_scene
  on_button_down 'escape', 'kb', :quit

  def start_scene
    # Draw Triangles
    x = Gamework::App.center_x - 50
    shades = [0xffbbbbbb00, 0xffffff00, 0xffffffbb]
    show_shape :triangle,  x: x+50, y: 350, size: 100, colors: shades
    show_shape :triangle,  x: x-50, y: 350, size: 100, colors: shades
    show_shape :triangle,  x: x,    y: 250, size: 100, colors: shades
    draw_background colors: [0xff000033, 0xff000033, 0xff000044, 0xff000033]

    # Draw text
    show_text "Example Game", y: 50, height: 50, width: Gamework::App.width, justify: :center
    show_text "Powered by Gamework v#{Gamework::VERSION}", y: 600, height: 15, width: Gamework::App.width, justify: :center
    draw_menu
  end

  def draw_menu
    x = Gamework::App.center_x - 160
    @menu = Gamework::Menu.new(x: x, y: 480, width: 300, margin: 10, padding: 10)
    @menu.add_option "Start Game", :end_scene
    @menu.add_option "Quit", :quit
    @menu.add_background color: 0x77000000
  end

  def before_update
    @menu.update
  end

  def before_draw
    @menu.draw
  end
end

class CoolScene < Gamework::Scene
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player
  on_button_toggle ['w', 's', 'a', 'd'], 'kb', :move_player, :stop_player

  has_assets "spec/media"

  # Load scene from yaml file
  build_scene "examples/advanced_map.yaml"

  def start_scene
    @score = 0
    @hud   = show_text "Score #{@score}", x: 5, y: 5, size: 20, fixed: true
    draw_background colors: [0xff000033, 0xff000033, 0xff000044, 0xff000033], fixed: true
  end

  def before_update
    @hud.update_text "Score #{@score}"
  end

  def map_direction_key(dir)
    # Maps WASD to directions

    map = {w: 'up', s: 'down', a: 'left', d: 'right'}
    map[dir.intern] || dir
  end

  def move_player(dir)
    dir = map_direction_key(dir)
    if player_collision(dir)
      player.turn(dir.intern)
      stop_player
    else
      player.move(dir.intern)
    end
  end

  def player_collision(dir)
    @actors.any? {|name, actor| player.collide?(actor, dir)}
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
  c.debug_mode = true
end

Gamework::App.start do
  Gamework::App << StartScene
  Gamework::App << CoolScene
end