require 'rubygems'
require 'gamework'
require 'pry'

Gamework::App.config do |c|
  c.width  = 800
  c.height = 640
  c.title  = "Ruby Spaceship"
end

class TitleScene < Gamework::Scene
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :quit
  on_button_down 'return', 'kb', :select_option
  on_button_up ['up', 'down'], 'kb', :move_cursor

  transition start: 'fade_in', end: 'fade_out', duration: 1.5

  def start_scene
    show_spaceship
    show_logo
    show_menu
    show_text Gamework::App.title, y: 50, height: 50, width: Gamework::App.width, justify: :center
    show_text "Powered by Gamework v#{Gamework::VERSION}", y: 600, height: 15, width: Gamework::App.width, justify: :center
    draw_background image: asset_path('background.jpg')
  end

  # Draw shapes on the screen
  def show_logo
    x = Gamework::App.center_x - 50
    shades = [0xffbbbbbb00, 0xffffff00, 0xffffffbb]
    show_shape :triangle, x: x, y: 250, size: 100, colors: shades
    # show_shape :triangle, x: x, y: 250, size: 100, colors: shades, angle: 180
  end

  # Draws an animating spaceship graphic
  def show_spaceship
    add_drawable Spaceship.new spritesheet: asset_path('spaceship.png'), y: 400, scale: 1
  end

  # Create menu with options
  def show_menu
    x = Gamework::App.center_x - 160
    @menu = Gamework::Menu.new x: x, y: 480, width: 300, margin: 10, padding: 10
    @menu.add_option "Start Game"
    @menu.add_option "Quit"
    @menu.add_background color: 0xaa000022
    @menu.add_cursor
    add_drawable(@menu)
  end

  def move_cursor(dir)
    play_sound :menu_move, asset_path('menu_move.wav')
    @menu.move_cursor(dir)
  end

  def select_option
    play_sound :menu_select, asset_path('menu_select.wav')
    case @menu.cursor_position
    when 0
      Gamework::App.next_scene 'space'
    when 1
      quit
    end
  end

  # Block user input when the game is paused
  # or during scene transitions
  def disallow_input?
    paused? || transition?
  end
end

class SpaceScene < Gamework::Scene
  has_assets "spec/media"
  on_button_down 'escape', 'kb', :end_scene
  on_button_down ['left', 'right', 'a', 'd'], 'kb', :turn_player
  on_button_down ['up', 'w'], 'kb', :accelerate_player
  on_button_down ['down', 's'], 'kb', :decelerate_player
  transition start: 'fade_in', end: 'fade_out', duration: 1.5

  def start_scene
    @score  = 0
    @stars  = []
    @hud    = show_text "Score", x: 5, y: 5, size: 20, fixed: true
    @player = Spaceship.new spritesheet: asset_path('spaceship.png')
    add_drawable(@player)
    draw_background image: asset_path('background.jpg')
  end

  def before_update
    @hud.update_text "Score #{@score}"
    update_stars
    gather_stars
  end

  # Maps WASD to directions
  def map_direction_key(dir)
    map = {w: 'up', a: 'left', d: 'right'}
    map[dir.intern] || dir
  end

  def turn_player(dir)
    @player.turn map_direction_key(dir)
  end

  def accelerate_player
    @player.accelerate
  end

  def decelerate_player
    @player.decelerate
  end

  # Adds a new star in a random
  # location within the viewport
  def add_star
    x = @camera_x + rand(Gamework::App.width-48-@camera_x)
    y = @camera_y + rand(Gamework::App.height-48-@camera_y)
    star = show_shape :square, image: asset_path('star.png'), size: 48, position: [x,y], center: true, color: random_color
    @stars << star
  end

  def random_color
    color = Gosu::Color.new(0xff000000)
    color.red   = rand(256 - 40) + 40
    color.green = rand(256 - 40) + 40
    color.blue  = rand(256 - 40) + 40
    color
  end

  # Adds one star per second over the 
  # course of 3 seconds, up to
  # 10 stars max
  def update_stars
    @star_timeout ||= 0
    @star_timeout += 1
    if @star_timeout == 60*3
      @star_timeout = 0
      add_star if @stars.count < 10
    end
  end

  # Collect points for stars that are touched
  # and delete them from the page
  def gather_stars
    @stars.select {|s| @player.touch?(s)}.each do |s|
      @score += 100
      @stars.delete(s)
      s.delete
      play_sound :star_collect, asset_path('menu_select.wav')
    end
  end

end

class Spaceship < Gamework::Drawable
  trait 'gamework::animated_sprite'
  trait 'gamework::physics'
  trait 'gamework::wrap'

  attributes x: Gamework::App.center_x,
             y: Gamework::App.center_y,
             width: 43,
             height: 43,
             scale: 2,
             animating: true

  def turn(dir)
    case dir.intern
    when :left
      rotate(-4.5)
    when :right
      rotate(4.5)
    end
  end
end

Gamework::App.start do
  Gamework::App << 'title'
end
