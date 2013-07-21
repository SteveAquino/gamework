require_relative '../../spec_helper'
 
describe Gamework::App do
  describe ".config" do
    it "should allow block style configuration" do
      Gamework::App.config do |c|
        c.width  = 1000
        c.height = 1000
        c.fullscreen = false
      end

      Gamework::App.width.should eq(1000)
      Gamework::App.height.should eq(1000)
      Gamework::App.fullscreen.should eq(false)
    end

    it "raises and error after window is drawn" do
      Gamework::App.stub("showing?") { true }
      expect {Gamework::App.config {|c| c.width = 100} }.to raise_error
    end
  end

  describe ".start" do
    it "creates a window object and calls show" do
      @called = false
      Gamework::Window.any_instance.stub(:show) { @called = true }
      Gamework::App.start
      @called.should be_true
    end

    it "only creates a window once" do
      @called = false
      Gamework::Window.any_instance.stub(:make_window) { @called = true }
      Gamework::App.start
      
      @called = false
      Gamework::App.start
      @called.should be_false
    end
  end

  describe ".window" do
    it "returns the current Gamework::Window instace" do
      Gamework::Window.any_instance.stub(:show)
      Gamework::App.start
      Gamework::App.window.should_not be_nil
    end
  end

  describe ".exit" do
    it "closes the current window object" do
      @called = false
      Gamework::Window.any_instance.stub(:close) { @called = true }
      Gamework::Window.any_instance.stub(:show)
      Gamework::App.start
      Gamework::App.exit
      @called.should be_true
    end
  end
end