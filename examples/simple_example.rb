require 'rubygems'
require 'gamework'

puts "Running Gamework Version #{Gamework::VERSION}"

class MyScene < Gamework::Scene

  # Set asset directory
  has_assets "spec/media"

  # Listen for input
  on_button_down 'escape', 'kb', :end_scene
  on_button_toggle ['up', 'down', 'left', 'right'], 'kb', :move_player, :stop_player

  def start_scene
    # Prepare the scene with music, a tileset, and actors

    # Load music
    load_song asset_path("song.mp3")

    # Draw map
    spritesheet = asset_path("tileset.png")
    mapfile     = asset_path("simple_map.txt")
    mapkey      = {'.' => 0, ',' => 1, '#' => 2, 't' => 3, 'x' => 4}
    create_tileset mapfile, 32, 32, spritesheet, mapkey

    # Create player and npcs with nested hash
    create_actors({
      player: {
        size: 30,
        position: [400, 320],
        spritesheet: asset_path("spritesheet.png"),
        follow: true
      },
      npc: {
        size: 30,
        position: [100, 100],
        spritesheet: asset_path("spritesheet.png")
      }
    })
  end

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
  c.title  = "Simple Example"
  # c.debug = true
end

Gamework::App.start do
  Gamework::App << MyScene
end