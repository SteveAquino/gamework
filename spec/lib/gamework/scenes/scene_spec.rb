require_relative '../../../spec_helper'
 
describe Gamework::Scene do
  let(:scene) { Gamework::Scene.new }
  let(:actor) { scene.add_actor(Gamework::Actor::Base.new) }

  before(:each) do
    Gamework::App.stub(:width)  { 100 }
    Gamework::App.stub(:height) { 100 }
  end

  after(:each) { scene.class.instance_variable_set '@transition_options', nil }

  describe "hook methods" do
    describe "#update" do
      it "calls #before_update and #after_update" do
        expect(scene).to receive(:before_update)
        expect(scene).to receive(:after_update)
        scene.update
      end
    end

    describe "#draw" do
      it "calls #before_draw and #after_draw" do
        scene.stub(:draw_relative)
        expect(scene).to receive(:before_draw)
        expect(scene).to receive(:after_draw)
        scene.draw
      end
    end

    describe "#inside_viewport?" do
      it "returns true if an object is inside the viewport" do
        expect(scene.inside_viewport? actor).to be_true
        actor.set_position 101, 101
        expect(scene.inside_viewport? actor).to be_false
      end
    end

    describe "#end_scene"

    describe "#follow" do
      it "assigns a camera target" do
        scene.follow actor
        expect(scene.instance_variable_get "@camera_target").to be(actor)
      end
    end

    describe "#unfollow" do
      it "clears the camera target" do
        scene.follow actor
        scene.unfollow
        expect(scene.instance_variable_get "@camera_target").to be_nil
      end
    end
  end

  describe "#add_actor" do
    it "adds actors to the actors array" do
      actor = Gamework::Actor::Base.new x: 10, y: 10
      scene.add_actor actor
      expect(scene.actors).to eq([actor])
    end

    it "can be aliased as <<" do
      actor = Gamework::Actor::Base.new x: 10, y: 10, fixed: true
      expect(scene).to receive(:add_actor).with(actor)
      scene << actor
    end
  end

  describe "#create_tileset" do
    it "creates a new Tileset instance with given arguments" do
      Gamework::Tileset.any_instance.stub(:make_sprites)
      Gamework::Tileset.any_instance.stub(:make_tiles)
      scene.create_tileset("test.txt", 32, 32, "test.png")

      expect(scene.tileset).to_not be_nil
    end
  end

  describe "#create_actor" do
    it "calls add_actor with given arguments" do
      expect(scene).to receive(:add_actor)
      scene.create_actor x: 10, y: 10
    end

    it "builds a actor of a given type" do
      class CustomActor
        def initialize(options); end;
      end
      expect(scene).to receive(:add_actor)
      scene.create_actor({x: 10, y: 10}, 'custom_actor')
    end
  end

  describe "#_start_scene" do
    it "calls #start_scene" do
      expect(scene).to receive(:start_scene)
      scene._start_scene
    end

    it "calls #do_transition if @start_transition_options are set" do
      scene.class.transition start: 'fade_in', duration: 2
      expect(scene).to receive(:do_transition).with type: 'fade_in', duration: 2
      scene._start_scene
    end
  end

  describe "#end_scene" do
    it "marks the scene as ended" do
      scene.end_scene
      expect(scene.ended?).to be_true
    end

    it "calls #do_transition if @end_transition_options are set" do
      scene.class.transition end: 'fade_out', duration: 2
      expect(scene).to receive(:do_transition).with type: 'fade_out', duration: 2
      scene.end_scene
    end
  end

  describe "#do_transition" do
    it "creates a new Gamework::Transition instance" do
      scene.do_transition type: 'fade_in', duration: 2
      expect(scene.actors.first.kind_of? Gamework::Transition).to be_true
      expect(scene.transition?).to be_true
    end
  end

  describe ".transition" do
    it "sets an instance variable with transition arguments" do
      scene.class.transition start: 'fade_in', end: 'fade_out', duration: 2
      settings = scene.class.instance_variable_get '@transition_options'
      expect(settings[:start]).to eq({type: 'fade_in', duration: 2})
      expect(settings[:end]).to eq({type: 'fade_out', duration: 2})
    end
  end
  
end 
