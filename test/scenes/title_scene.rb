class TitleScene < Gamework::Scene
  has_assets 'media'

  on_button_up 'return', 'kb', :select_option
  on_button_up ['up', 'down'], 'kb', :move_cursor

  def start_scene
    show_triforce
    show_link
    show_menu
    show_credits
    show_text Gamework::App.title, y: 50, height: 50, width: Gamework::App.width, justify: :center
    draw_background image: asset_path('background.jpg', 'images')
  end

  def show_triforce
    # Draw three triangles centered in the screen
    x = Gamework::App.center_x - 50
    shades = [0xffbbbbbb00, 0xffffff00, 0xffffffbb]
    show_shape :triangle,  x: x,    y: 250, size: 100, colors: shades
    show_shape :triangle,  x: x+50, y: 350, size: 100, colors: shades
    show_shape :triangle,  x: x-50, y: 350, size: 100, colors: shades
  end

  def show_link
    # Draws an animating Link graphic
    x = Gamework::App.center_x
    show_animation spritesheet: asset_path('link.png', 'images'), x: x, y: 400, cutoff: 11, repeat: true
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

  def show_credits
    # Draw credits at bottom
    y = Gamework::App.height - 20
    show_text "Powered by Gamework v#{Gamework::VERSION}", x: 5, y: y, size: 15
    x = Gamework::App.width - 160
    show_text "Made by Steve Aquino", x: x, y: y, size: 15
  end

  def move_cursor(dir)
    @menu.move_cursor(dir)
    play_sound :menu_move, asset_path('menu_move.wav', 'sounds')
  end

  def select_option
    case @menu.cursor_position
    when 0
      Gamework::App << LoadGameScene
      end_scene
    when 1
      quit
    end
    play_sound :menu_select, asset_path('menu_select.wav', 'sounds')
  end
end