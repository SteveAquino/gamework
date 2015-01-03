require 'rubygems'
require 'gamework'
require 'pry'

# Opening Title Scene
class StartScene < Gamework::Scene
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :quit
  on_button_down 'return', 'kb', :select_option
  on_button_up ['up', 'down'], 'kb', :move_cursor

  def start_scene
    # Draw Triangles
    show_triforce
    # Draw background gradient
    draw_background colors: [0xff000033, 0xff000033, 0xff000066]
    # Draw menu
    show_menu
    # Draw text
    show_text Gamework::App.title, y: 50, height: 50, width: Gamework::App.width, justify: :center
    show_text "Powered by Gamework v#{Gamework::VERSION}", y: 600, height: 15, width: Gamework::App.width, justify: :center
  end

  def show_triforce
    # Draw three triangles centered in the screen
    x = Gamework::App.center_x - 50
    shades = [0xffbbbbbb00, 0xffffff00, 0xffffffbb]
    show_shape :triangle, x: x,    y: 250, size: 100, colors: shades
    show_shape :triangle, x: x+50, y: 350, size: 100, colors: shades
    show_shape :triangle, x: x-50, y: 350, size: 100, colors: shades
  end

  def show_menu
    # Create menu with options
    x = Gamework::App.center_x - 160
    @menu = Gamework::Menu.new x: x, y: 480, width: 300, margin: 10, padding: 10
    @menu.add_option "Start Game"
    @menu.add_option "Quit"
    @menu.add_background color: 0xaa000022
    @menu.add_cursor
    add_drawable @menu
  end

  def move_cursor(dir)
    play_sound :menu_move, asset_path('menu_move.wav')
    @menu.move_cursor(dir)
  end

  def select_option
    play_sound :menu_select, asset_path('menu_select.wav')
    case @menu.cursor_position
    when 0
      # Load the map scene
      Gamework::App.next_scene 'map'
    when 1
      # Exit the game
      quit
    end
  end
end

# Map Scene
class MapScene < Gamework::Scene
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player
  on_button_toggle ['w', 's', 'a', 'd'], 'kb', :move_player, :stop_player

  # Load scene from yaml file
  build_scene "examples/zelda.yaml"

  # Maps WASD to directions
  def map_direction_key(dir)
    map = {w: 'up', s: 'down', a: 'left', d: 'right'}
    map[dir.intern] || dir
  end

  def move_player(dir)
    dir = map_direction_key(dir)
    @player.move dir.intern
  end

  def stop_player
    @player.stop
  end
end

class Link < Gamework::Drawable
  trait 'gamework::movement'
  trait 'gamework::animated_sprite'

  attributes width:  30,
             height: 30,
             scale:  2,
             split_sprites: true
end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Simple Zelda"
end

Gamework::App.start do
  Gamework::App << 'start'
end
