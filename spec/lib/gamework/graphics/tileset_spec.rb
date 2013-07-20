require_relative '../../../spec_helper'
 
describe Gamework::Tileset do

	describe "#make_sprites" do
		it "creates an array of sprites" do
			path    = File.expand_path "../../../../media/tileset.png", __FILE__
			window  = Gamework::Window.new(1,1)
			tileset = Gamework::Tileset.new(32, 32, path)
			Gamework::App.stub(:window).and_return(window)
			Gosu::Image.any_instance.stub(:initialize)

			tileset.make_sprites
			tileset.sprites.length.should eq(4)
			tileset.sprites.each {|t| t.is_a?(Gosu::Image).should be_true }
		end
	end

	describe "#make_tiles" do
		context "without mapkey" do
			it "creates a nested array of tiles" do
				col     = [0,1,2,3]
				path    = File.expand_path "../../../../media/map.txt", __FILE__
				tileset = Gamework::Tileset.new(32, 32, "test.png")
				tileset.make_tiles(path)
				tileset.tiles.should eq([col,col,col,col])
			end
		end

		context "with mapkey" do
			it "creates a nested array of tiles" do
				col     = [0,1,2,3,4]
				path    = File.expand_path "../../../../media/map2.txt", __FILE__
				mapkey  = {'.' => 0, ',' => 1, '#' => 2, 't' => 3, 'x' => 4}
				tileset = Gamework::Tileset.new(32, 32, "test.png", mapkey)
				tileset.make_tiles(path)
				tileset.tiles.should eq([col,col,col,col])
			end
		end
	end

	describe "#get_tile" do
		it "returns the correct sprite index for a tile at a given x,y coordinate" do
			tileset = Gamework::Tileset.new(32, 32, "test.png")
			tiles   = [[0,1,2,3],[1,2,3,0],[2,3,1,0],[3,0,1,2]]
			tileset.instance_variable_set "@tiles", tiles
			tileset.get_tile(2,0).should eq(2)
		end
	end

	describe "#get_sprite" do
		it "returns the correct sprite index for a tile at a given x,y coordinate" do
			tileset = Gamework::Tileset.new(32, 32, "test.png")
			tiles   = [[0,1,2,3],[1,2,3,0],[2,3,1,0],[3,0,1,2]]
			tileset.instance_variable_set "@tiles", tiles
			tileset.instance_variable_set "@sprites", [:a,:b,:c,:d]
			tileset.get_sprite(2,0).should eq(:c)
		end
	end

	describe "#draw_tile" do
		it "draws the correct sprite for a given x,y coordinate" do
			tileset = Gamework::Tileset.new(32, 32, "test.png")
			tiles   = [[0,1,2,3],[1,2,3,0],[2,3,1,0],[3,0,1,2]]
			tileset.instance_variable_set "@tiles", tiles
			class MockSprite
				attr_reader :drawn
				def draw(a,b,c)
					@drawn = true
				end
			end
			grass1 = MockSprite.new()
			grass2 = MockSprite.new()
			bush   = MockSprite.new()
			tree   = MockSprite.new()
			tileset.instance_variable_set "@sprites", [grass1,grass2,bush,tree]

			x,y,z  = 0,64,0
			tileset.draw_tile(2,0)
			bush.drawn.should eq(true)
		end
	end
end