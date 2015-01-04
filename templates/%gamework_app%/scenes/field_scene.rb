class FieldScene < Gamework::Scene
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player
  on_button_toggle 'tab', 'kb', :show_debug, :hide_debug

  # Load scene from yaml file
  build_scene "maps/field.yaml"

  def move_player(dir)
    @player.move(dir.intern)
  end

  def stop_player
    @player.stop
  end
end
