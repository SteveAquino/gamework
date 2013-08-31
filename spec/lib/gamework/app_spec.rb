require_relative '../../spec_helper'
 
describe Gamework::App do
  describe ".config" do
    it "should allow block style configuration" do
      Gamework::App.config do |c|
        c.width  = 1000
        c.height = 1000
        c.fullscreen = false
        c.debug = true
      end

      Gamework::App.width.should eq(1000)
      Gamework::App.height.should eq(1000)
      Gamework::App.fullscreen.should eq(false)
      Gamework::App.debug_mode?.should be_true
    end

    it "raises and error after window is drawn" do
      Gamework::App.stub("showing?") { true }
      expect {Gamework::App.config {|c| c.width = 100} }.to raise_error
    end
  end

  describe ".start" do
    it "creates a window object and calls show" do
      Gamework::App.stub(:make_window)
      Gamework::App.stub(:show)
      Gamework::App.should_receive(:make_window).and_return(true)
      Gamework::App.should_receive(:show)
      Gamework::App.start
    end

    it "raises an error if called twice" do
      Gamework::App.stub("showing?").and_return(true)
      expect {Gamework::App.start}.to raise_error
    end

    it "takes a block argument that is called before window is shown" do
      Gamework::App.stub(:make_window)
      Gamework::App.stub(:show)
      
      @called = false
      Gamework::App.start { @called = true }
      @called.should be_true
    end
  end

  describe ".window" do
    it "always returns the same Gamework::Window instance" do
      Gamework::App.make_window
      Gamework::App.window.should eq(Gamework::App.window)
    end
  end

  describe ".update" do
    it "delegates to the current scene" do
      scene = Gamework::Scene.new
      Gamework::App.stub(:current_scene).and_return(scene)
      scene.should_receive(:update)
      Gamework::App.update
    end

    it "moves to the next scene if the current has ended" do
      scene1 = Gamework::Scene.new
      scene2 = Gamework::Scene.new
      scene1.stub("ended?").and_return(true)
      Gamework::App.class_variable_set "@@scenes", [scene1, scene2]
      Gamework::App.update
      Gamework::App.current_scene.should eq(scene2)
    end

    it "exits if there are no more scenes" do
      Gamework::App.stub(:current_scene).and_return(nil)
      Gamework::App.should_receive(:exit)
      Gamework::App.update
    end
  end

  describe ".quit" do
    it "reduces the collection to a single scene" do
      scene1 = Gamework::Scene.new
      scene2 = Gamework::Scene.new
      Gamework::App.class_variable_set "@@scenes", [scene1, scene2]
      Gamework::App.quit
      Gamework::App.class_variable_get("@@scenes").should eq([scene1])
    end

    it "ends the current scene" do
      scene1 = Gamework::Scene.new
      Gamework::App.class_variable_set "@@scenes", [scene1]
      scene1.should_receive(:end_scene)
      Gamework::App.quit
    end
  end

  describe ".exit" do
    it "closes the current window object" do
      @called = false
      Gamework::Window.any_instance.stub(:close) { @called = true }
      Gamework::App.stub(:show)
      Gamework::App.start
      Gamework::App.exit
      @called.should be_true
    end
  end

  describe ".add_scene" do
    it "appends a scene instance to the collection" do
      Gamework::App.class_variable_set "@@scenes", []
      Gamework::App.add_scene Gamework::Scene
      Gamework::App.class_variable_get("@@scenes").size.should eq(1)
    end

    it "only allows instances of children of Gamework::Scene" do
      expect {Gamework::App.add_scene(String)}.to raise_error("Must be type of Gamework::Scene or subclass")
    end

    it "can be called as <<" do
      Gamework::App.stub(:add_scene)
      Gamework::App.should_receive(:add_scene)
      Gamework::App << Gamework::Scene
    end
  end
end