class LoadGameScene < Gamework::Scene
  on_button_down 'escape', 'kb', :back_to_title
  on_button_up 'return', 'kb', :select_option
  on_button_up ['up', 'down'], 'kb', :move_cursor

  def start_scene
    # show_link
    # load_game_saves
    @game_saves = ["Save 1","Save 2","Save 3"]
    show_menu
    draw_background colors: [0xff000055,0xff000055,0xff000099,0xff000055]
  end

  def show_menu
    # Create menu with options
    @menu = Gamework::Menu.new x: 80, y: 80, width: 600, margin: 10, padding: 10, justify: :left
    @game_saves.each_with_index do |save, y|
      @menu.add_option(save)
      show_link 90 + y * 40
    end
    @menu.add_background color: 0xaa000022
    @menu.add_cursor
    add_drawable(@menu)
  end

  def show_link(y)
    # Draws an animating Link graphic
    x = 670
    # show_animation spritesheet: asset_path('link.png', 'images'), x: x, y: y, cutoff: 11, repeat: true
  end

  def move_cursor(dir)
    @menu.move_cursor(dir)
    play_sound :menu_move, asset_path('menu_move.wav', 'sounds')
  end

  def select_option
    i = @menu.cursor_position
    # load or start game
    play_sound :menu_select, asset_path('menu_select.wav', 'sounds')
    start_game(FieldScene)
  end

  def start_game(scene)
    Gamework::App << scene
    end_scene
  end

  def back_to_title
    Gamework::App << TitleScene
    end_scene
  end
end
