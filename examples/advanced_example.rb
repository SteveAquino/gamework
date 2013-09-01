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
    show_logo
    # Draw Animation
    show_link
    # Draw background image
    draw_background image: asset_path('background.jpg')
    # Draw menu
    show_menu
    # Draw text
    show_text "Example Game", y: 50, height: 50, width: Gamework::App.width, justify: :center
    show_text "Powered by Gamework v#{Gamework::VERSION}", y: 600, height: 15, width: Gamework::App.width, justify: :center
  end

  def show_logo
    # Draw three triangles centered in the screen
    x = Gamework::App.center_x - 50
    shades = [0xffbbbbbb00, 0xffffff00, 0xffffffbb]
    show_shape :triangle,  x: x,    y: 250, size: 100, colors: shades
    show_shape :triangle,  x: x+50, y: 350, size: 100, colors: shades
    show_shape :triangle,  x: x-50, y: 350, size: 100, colors: shades
  end

  def show_link
    x = Gamework::App.center_x
    show_animation spritesheet: asset_path('spritesheet.png'), x: x, y: 400, cutoff: 11, repeat: true
  end

  def show_menu
    # Create menu with options
    x = Gamework::App.center_x - 160
    @menu = Gamework::Menu.new x: x, y: 480, width: 300, margin: 10, padding: 10
    @menu.add_option "Start Game"
    @menu.add_option "Quit"
    @menu.add_background color: 0xaa000022
    @menu.add_cursor
    add_drawable(@menu)
  end

  def move_cursor(dir)
    @menu.move_cursor(dir)
    play_sound :menu_move, asset_path('menu_move.wav')
  end

  def select_option
    case @menu.cursor_position
    when 0
      end_scene
    when 1
      quit
    end
    play_sound :menu_select, asset_path('menu_select.wav')
  end
end

# Map Scene
class CoolScene < Gamework::Scene
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player
  on_button_toggle ['w', 's', 'a', 'd'], 'kb', :move_player, :stop_player
  on_button_toggle 'tab', 'kb', :show_debug, :hide_debug

  # Load scene from yaml file
  build_scene "examples/advanced_map.yaml"

  def start_scene
    @score = 0
    @hud   = show_text "Score #{@score}", x: 5, y: 5, size: 20, fixed: true
    @stars = []
  end

  def before_update
    @hud.update_text "Score #{@score}"
    update_stars
  end

  def map_direction_key(dir)
    # Maps WASD to directions

    map = {w: 'up', s: 'down', a: 'left', d: 'right'}
    map[dir.intern] || dir
  end

  def move_player(dir)
    dir = map_direction_key(dir)
    player.move(dir.intern)
    gather_stars
  end

  def stop_player
    player.stop
  end
  
  def player
    @actors[:player]
  end

  def add_star
    # Adds a new star in a random
    # location within the viewport

    x = @camera_x + rand(Gamework::App.width-48-@camera_x)
    y = @camera_y + rand(Gamework::App.height-48-@camera_y)
    star = show_shape :square, image: asset_path('star.png'), size: 48, position: [x,y]
    @stars << star
  end

  def update_stars
    # Adds one star ever 3 seconds,
    # up to 5 total

    @star_timeout ||= 0
    @star_timeout += 1
    if @star_timeout == 60*3
      @star_timeout = 0
      add_star if @stars.count < 5
    end
  end

  def gather_stars
    # Collect points for stars that are touched
    # and delete them from the page

    @stars.select {|s| player.touch?(s)}.each do |s|
      @score += 100
      @stars.delete(s)
      s.delete
    end
  end

  def show_debug
    if Gamework::App.debug_mode?
      time  = Time.now.localtime.strftime("%r")
      title = Gamework::App.title
      Gamework::App.caption = "#{title} (#{Gosu.fps} fps), Current Time: #{time}"
    end
  end

  def hide_debug
    Gamework::App.caption = Gamework::App.title
  end
end

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Advanced Example"
  c.debug = true
end

Gamework::App.start do
  Gamework::App << StartScene
  Gamework::App << CoolScene
end