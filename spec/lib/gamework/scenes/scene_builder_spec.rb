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
      expect(data.keys).to eq(['song', 'tileset', 'actor', 'custom'])
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

  describe "#build_actor" do
    it "creates a actor instance with given options" do
      expect(scene).to receive(:create_actor).with({x:10, y:10}, 'actor')
      builder.build_actor('actor', x: 10, y: 10)
    end

    it "saves actor as an instance variable" do
      actor = Gamework::Actor::Base.new
      scene.stub(:create_actor).and_return(actor)
      builder.build_actor('actor', x: 10, y: 10, name: 'cool_guy', follow: true)
      expect(scene.instance_variable_get("@cool_guy")).to eq(actor)
      expect(scene.instance_variable_get("@camera_target")).to eq(actor)
    end
  end

  describe "#build_scene" do
    it "delegates correct data to scene" do
      actor = Gamework::Actor::Base.new
      builder.load
      scene.stub(:create_actor).and_return(actor)
      expect(scene).to receive(:load_song).with('song.wav', true)
      expect(scene).to receive(:create_tileset).with(30, 'tileset.png', 'map.txt')
      expect(scene).to receive(:create_actor).with({x:10, y:10}, 'actor')
      expect(scene).to receive(:create_actor).with({x:10, y:10}, 'custom')

      builder.build_scene
      expect(scene.instance_variable_get("@player")).to eq(actor)
    end
  end

end
