require_relative '../../spec_helper'
 
describe Gamework::Window do
  describe "#update" do
    it "triggers Gamework::App.update" do
      @called = false
      @window ||= Gamework::Window.new(1,1)
      Gamework::App.stub(:update) { @called = true }
      Gamework::App.stub(:window) { @window }
      @window.update and @window.close
      @called.should be_true
    end
  end

  describe "#draw" do
    it "triggers Gamework::App.draw" do
      @called = false
      @window ||= Gamework::Window.new(1,1)
      Gamework::App.stub(:draw) { @called = true }
      Gamework::App.stub(:window) { @window }
      @window.draw and @window.close
      @called.should be_true
    end
  end

  describe "#button_down" do
    it "triggers Gamework::App.button_down" do
      @called = false
      @window ||= Gamework::Window.new(1,1)
      Gamework::App.stub(:button_down) { @called = true }
      Gamework::App.stub(:window) { @window }
      @window.button_down(1) and @window.close
      @called.should be_true
    end
  end
end