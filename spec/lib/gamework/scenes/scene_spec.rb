require_relative '../../../spec_helper'
 
describe Gamework::Scene do
  let(:scene) { Gamework::Scene.new }

  before(:each) do
    Gamework::App.stub(:width)  { 100 }
    Gamework::App.stub(:height) { 100 }
  end

  after(:each) { scene.class.instance_variable_set '@transition_options', nil }

  describe "hook methods" do
    describe "#update" do
      it "calls #before_update and #after_update" do
        scene.should_receive(:before_update)
        scene.should_receive(:after_update)
        scene.update
      end
    end

    describe "#draw" do
      it "calls #before_draw and #after_draw" do
        scene.stub(:draw_relative)
        scene.should_receive(:before_draw)
        scene.should_receive(:after_draw)
        scene.draw
      end
    end
  end

  describe "#add_drawable" do
    it "adds drawables to the drawables array" do
      drawable = Gamework::Drawable.new x: 10, y: 10
      scene.add_drawable drawable
      scene.drawables.should eq([drawable])
    end

    it "can be aliased as <<" do
      drawable = Gamework::Drawable.new x: 10, y: 10, fixed: true
      scene.should_receive(:add_drawable).with(drawable)
      scene << drawable
    end
  end

  describe "#create_tileset" do
    it "creates a new Tileset instance with given arguments" do
      Gamework::Tileset.any_instance.stub(:make_sprites)
      Gamework::Tileset.any_instance.stub(:make_tiles)
      scene.create_tileset("test.txt", 32, 32, "test.png")

      scene.tileset.should_not be_nil
    end
  end

  describe "#create_drawable" do
    it "calls add_drawable with given arguments" do
      scene.should_receive(:add_drawable)
      scene.create_drawable x: 10, y: 10
    end

    it "builds a drawable of a given type" do
      class CustomDrawable
        def initialize(options); end;
      end
      scene.should_receive(:add_drawable)
      scene.create_drawable({x: 10, y: 10}, 'custom_drawable')
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
      expect(scene.drawables.first.kind_of? Gamework::Transition).to be_true
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