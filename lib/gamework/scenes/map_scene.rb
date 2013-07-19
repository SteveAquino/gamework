module Gamework
	class MapScene < Gamework::Scene
		# MapScenes are the heart of gameplay for isometric
		# games.  MapScenes hold the instance of the player,
		# NPCs, Animations, and MapEvents

		attr_reader   :width, :height, :camera_x, :camera_y,
									:player, :animation_handler

		def initialize
			# super

			# The scrolling position is relative to the
			# top left corner of the screen.
			@camera_x = @camera_y = 0

			# @animation_handler = AnimationHandler.new
			# @player = Player.new(@name, GameSaves.all.length)
			# @hud = Hud.new(@player)

			# Mark self as observer to watch for
			# important changes to the player
			# @player.add_observer(self, :observe)
		end

		def update
		# 	@player.update
		# 	Npc.update
		# 	Event.update
		# 	@hud.update
		# 	@animation_handler.update
		# 	update_camera(@player)
			super
		end

		def draw
			# Static visualizations go here
			# @player.draw
			# @hud.draw
		  # @dialogue.draw unless @dialogue.nil?

			# Objects that scroll with the map go here
			translate(-@camera_x, -@camera_y) do
			  # @player.draw
			  # Npc.draw
			  # Event.draw
			  # @animation_handler.draw
			  # draw_tiles
			  super
			end
		end

		def translate(camera_x, camera_y, &block)
			# Ties into Gosu::Window#translate method to 
			# pan graphics with user movement

			# Gamework::App.window.translate(camera_x, camera_y) { yield }
		end

		# def observe(options={})
		# 	# Custom observe function that watches various
		# 	# objects on the map and allows animations, ect.. 
		# 	# to be arbitrarily created and passed up to the
		# 	# parent scene

		# 	if animation = options[:animation]
		# 		@animation_handler.add_to_queue(animation)
		# 	end
		# end

		# def update_camera(target)
		# 	half_width  = GameConstants::ScreenWidth / 2
		# 	half_height = GameConstants::ScreenHeight / 2
			
	 #  	@camera_x = [
	 #  		[target.x - (half_width),  0].max,
	 #  		self.width * Tiles::Size - half_width
	 #  	].min
	 #  	@camera_y = [
	 #  		[target.y - (half_height), 0].max,
	 #  		self.height * Tiles::Size - half_height
	 #  	].min
	 #  end

	 #  def draw_tiles
	 #  	# TODO: Very primitive drawing function:
		# 	# Draws all the tiles, some off-screen, some on-screen.

		# 	@height.times do |y|
		# 		@width.times do |x|
		# 			tile = @tiles[x][y]
		# 			if tile
		# 			# Draw the tile with an offset (tile images have some overlap)
		# 			# Scrolling is implemented here just as in the game objects.
		# 				@tileset[tile].draw(x * Tiles::GraphicSize - Tiles::Padding,
		# 													  y * Tiles::GraphicSize - Tiles::Padding,
		# 													  ZOrder::Background)
		# 			end
		# 		end
		# 	end
		# end

		# def button_down(id)
		# 	@player.button_down(id)
		# 	case id
		# 		# Temporary testing controls
		# 		# TODO: Add testing console/API

		# 		when Gosu::Button::KbEscape
		# 			$game.close
		# 		when Gosu::Button::KbR
		# 			@dialogue = Dialogue.new("Hello #{@player.name}", "This is a new Dialogue window!")
		# 		when Gosu::Button::KbU
		# 			@dialogue.close
		# 			@dialogue = nil
		# 			$game.save(@player.save_file)
		# 		when Gosu::Button::KbE
		# 			Npc.new(100, 100, "link")
		# 	end
		# end

		# # Solid at a given pixel position?
		# def solid?(x, y)
		# 	y < 0 || @tiles[x / 32][y / 32]
		# end

		# def load_tileset(mapfile, tileset)
		# 	# Load GraphicSizexGraphicSize tiles, Padding overlap in all four directions.
		# 	@tileset = Gosu::Image.load_tiles($game, "media/tilesets/#{tileset}", Tiles::GraphicSize, Tiles::GraphicSize, true)
		
		# 	# Provided with a mapfile and a tileset graphic, a map
		# 	# can be drawn with various properties.  The mapfile
		# 	# is a plain text document with symbols mapped to
		# 	# sprites in the tileset graphic.
		# 	lines   = File.readlines("app/maps/#{mapfile}.txt").map { |line| line.chomp }
		# 	@height = lines.size
		# 	@width  = lines[0].size
		# 	@tiles  = Array.new(@width) do |x|
		# 		Array.new(@height) do |y|
	 #    		case lines[y][x, 1]
	 #    		when '.'
	 #    			Tiles::Grass1
		# 			when ','
		# 				Tiles::Grass2
		# 			when '#'
		# 				Tiles::Bush
		# 			when 't'
		# 				Tiles::Tree
		# 			when 'x'
		# 				nil
		# 			else
		# 				nil
		# 			end
		# 		end
		# 	end
		# end
	end
end