require_relative '../../../spec_helper'
 
describe Gamework::SceneBuilder do
  let(:scene) { Gamework::Scene.new }
  let(:builder) do
    path = File.expand_path('../../../../media/test.yaml', __FILE__)
    Gamework::SceneBuilder.new(scene, path)
  end

  describe "#load" do
    it "reads a yaml file and initializes the scene" do
      data = builder.load
      expect(data.keys).to eq(['song', 'tileset', 'drawable', 'custom'])
    end
  end

  describe "#build_song" do
    it "loads a song on the scene instance" do
      expect(scene).to receive(:load_song).with('song.wav', true)
      builder.build_song(songfile: 'song.wav', autoplay: true)
    end
  end

  describe "#build_tileset" do
    it "loads a tileset on the scene instance" do
      expect(scene).to receive(:create_tileset).with(30, 'tileset.png', 'map.txt')
      builder.build_tileset(tile_size: 30, spritesheet: 'tileset.png', mapfile: 'map.txt')
    end
  end

  describe "#build_drawable" do
    it "creates a drawable instance with given options" do
      expect(scene).to receive(:create_drawable).with({x:10, y:10}, 'drawable')
      builder.build_drawable('drawable', x: 10, y: 10)
    end

    it "saves drawable as an instance variable" do
      drawable = Gamework::Drawable.new
      scene.stub(:create_drawable).and_return(drawable)
      builder.build_drawable('drawable', x: 10, y: 10, name: 'cool_guy', follow: true)
      expect(scene.instance_variable_get("@cool_guy")).to eq(drawable)
      expect(scene.instance_variable_get("@camera_target")).to eq(drawable)
    end
  end

  describe "#build_scene" do
    it "delegates correct data to scene" do
      drawable = Gamework::Drawable.new
      builder.load
      scene.stub(:create_drawable).and_return(drawable)
      expect(scene).to receive(:load_song).with('song.wav', true)
      expect(scene).to receive(:create_tileset).with(30, 'tileset.png', 'map.txt')
      expect(scene).to receive(:create_drawable).with({x:10, y:10}, 'drawable')
      expect(scene).to receive(:create_drawable).with({x:10, y:10}, 'custom')

      builder.build_scene
      expect(scene.instance_variable_get("@player")).to eq(drawable)
    end
  end

end