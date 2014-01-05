require_relative '../../spec_helper'

class TestScene < Gamework::Scene; end;
 
describe Gamework::App do

  describe "event delegation" do
    %w(update draw).each do |event|
      it "delegates .#{event} to the current scene" do
        scene = Gamework::Scene.new
        scene.should_receive(event)
        Gamework::App.class_variable_set "@@scenes", [scene]
        Gamework::App.send(event)
      end
    end

    %w(button_down button_up).each do |event|
      it "delegates .#{event} to the current scene" do
        scene = Gamework::Scene.new
        scene.should_receive(event).with(1)
        Gamework::App.class_variable_set "@@scenes", [scene]
        Gamework::App.send(event, 1)
      end
    end
  end

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
      Gamework::App.fullscreen.should be_false
      Gamework::App.debug_mode?.should be_true
    end

    it "raises an error after window is drawn" do
      Gamework::App.stub("showing?") { true }
      expect {Gamework::App.config {|c| c.width = 100} }.to raise_error
    end
  end

  describe ".show" do
    it "sets an instance variable" do
      window = double("Gamework::Window")
      window.stub(:show)
      window.stub(:caption)
      Gamework::App.stub(:window).and_return { window }
      Gamework::App.show
      Gamework::App.showing?.should be_true
    end
  end

  describe ".make_window" do
    it "passes configuration settings to the window" do
      Gamework::Window.should_receive(:new).with(100,100,false)
      Gamework::App.stub("showing?").and_return(false)
      Gamework::App.stub(:set_default_caption)
      Gamework::App.width      = 100
      Gamework::App.height     = 100
      Gamework::App.fullscreen = false
      Gamework::App.make_window
    end

    it "sets a default caption" do
      Gamework::App.stub("showing?").and_return(false)
      Gamework::App.should_receive('set_default_caption')
      Gamework::App.make_window
    end
  end

  describe ".make_logger" do
    it "creates a new instance of Gamework::Logger" do
      logger = Gamework::App.make_logger('my_logfile.txt')
      expect(logger.kind_of? Gamework::Logger).to be_true
    end
  end

  describe ".set_default_caption" do
    it "sets a caption on the window" do
      window = double("Gamework::Window")
      expect(window).to receive(:caption=).with('Test Game')
      Gamework::App.stub(:window).and_return(window)
      Gamework::App.stub("showing?").and_return(false)
      Gamework::App.title = 'Test Game'
      Gamework::App.set_default_caption
    end
  end

  describe ".window" do
    it "always returns the same Gamework::Window instance" do
      Gamework::App.make_window
      Gamework::App.window.should eq(Gamework::App.window)
    end
  end

  describe ".start" do
    it "creates a window object and calls show" do
      Gamework::App.stub("showing?").and_return(false)
      expect(Gamework::App).to receive(:make_window)
      expect(Gamework::App).to receive(:make_logger)
      expect(Gamework::App).to receive(:show)
      Gamework::App.start
    end

    it "raises an error if called twice" do
      Gamework::App.stub("showing?").and_return(true)
      expect {Gamework::App.start}.to raise_error
    end

    it "takes a block argument that is called before window is shown" do
      Gamework::App.stub("showing?").and_return(false)
      Gamework::App.stub(:make_window)
      Gamework::App.stub(:make_logger)
      Gamework::App.stub(:show)
      
      @called = false
      Gamework::App.start { @called = true }
      expect(@called).to be_true
    end
  end

  describe ".update" do
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
      scene1.should_receive(:end_scene)
      Gamework::App.class_variable_set "@@scenes", [scene1]
      Gamework::App.quit
    end
  end

  describe ".exit" do
    it "closes the current window object" do
      Gamework::Window.any_instance.stub(:close)
      Gamework::Window.any_instance.should_receive(:close)
      Gamework::App.stub(:show)
      Gamework::App.exit
    end
  end

  describe ".string_to_scene_class" do
    it "transforms a string into a class" do
      class TitleScene < Gamework::Scene; end;
      class_name = Gamework::App.string_to_scene_class 'title'
      class_name.should eq(TitleScene)
    end

    it "transforms dashes to camel case" do
      class MyCoolScene < Gamework::Scene; end;
      class_name = Gamework::App.string_to_scene_class 'my-cool'
      class_name.should eq(MyCoolScene)
    end
  end

  describe ".add_scene" do
    it "appends a scene instance to the collection" do
      Gamework::App.class_variable_set "@@scenes", []
      Gamework::App.add_scene Gamework::Scene
      Gamework::App.class_variable_get("@@scenes").size.should eq(1)
    end

    it "works with a string argument" do
      Gamework::App.class_variable_set "@@scenes", []
      Gamework::App.add_scene 'test'
      Gamework::App.class_variable_get("@@scenes").size.should eq(1)
    end

    it "can be called as <<" do
      Gamework::App.stub(:add_scene)
      Gamework::App.should_receive(:add_scene).with(Gamework::Scene)
      Gamework::App << Gamework::Scene
    end
  end

  describe ".next_scene" do
    it "ends the current scene" do
      Gamework::App.class_variable_set "@@scenes", [Gamework::Scene.new]
      Gamework::App.next_scene Gamework::Scene
      Gamework::App.current_scene.ended?.should be_true
    end
    
    it "appends another instance to the array" do
      Gamework::App.class_variable_set "@@scenes", []
      Gamework::App.next_scene Gamework::Scene
      Gamework::App.class_variable_get("@@scenes").size.should eq(1)
    end
    
    it "works with a string argument" do
      Gamework::App.class_variable_set "@@scenes", []
      Gamework::App.next_scene 'test'
      Gamework::App.class_variable_get("@@scenes").size.should eq(1)
    end
  end

  describe ".center_x" do
    it "returns the horizontal center point of the window" do
      Gamework::App.width = 100
      Gamework::App.center_x.should eq(50)
    end
  end

  describe ".center_y" do
    it "returns the vertical center point of the window" do
      Gamework::App.height = 100
      Gamework::App.center_y.should eq(50)
    end
  end

  describe ".center" do
    it "returns the x,y cooridnates of the center point of the window" do
      Gamework::App.width  = 100
      Gamework::App.height = 100
      Gamework::App.center.should eq([50,50])
    end
  end
end