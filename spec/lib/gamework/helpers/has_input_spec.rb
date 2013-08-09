require_relative '../../../spec_helper'
 
class MockController
  include Gamework::HasInput
  def my_method
  end
end

class MockControllerWithCallbacks
  include Gamework::HasInput
  def my_method(id)
  end

  def update
  end

  def button_down?(id)
    true
  end
end

describe Gamework::HasInput do
  describe ".gosu_button_id" do
    it 'maps strings to a Gosu::Button constant' do
      MockController.gosu_button_id('a', 'kb').should eq(Gosu::Button::KbA)
    end
  end

  describe ".register_callback" do
    it 'registers a callback for a given button id' do
      mapping = MockController.button_down_mapping
      MockController.register_callback mapping, 'a', 'kb', :my_method
      MockController.button_down_mapping[Gosu::Button::KbA].should_not be_nil
    end

    it 'takes an array of button ids' do
      mapping = MockController.button_down_mapping
      MockController.register_callback mapping, ['b', 'c'], 'kb', :my_method
      MockController.button_down_mapping[Gosu::Button::KbB].should_not be_nil
      MockController.button_down_mapping[Gosu::Button::KbC].should_not be_nil
    end
  end

  describe ".on_button_down" do
    it 'registers a callback in button_down_mapping' do
      MockController.on_button_down 'd', 'kb', :my_method
      MockController.button_down_mapping[Gosu::Button::KbD].should_not be_nil
    end
  end

  describe ".on_button_up" do
    it 'registers a callback in button_down_mapping' do
      MockController.on_button_up 'e', 'kb', :my_method
      MockController.button_up_mapping[Gosu::Button::KbE].should_not be_nil
    end
  end

  describe ".on_button_toggle" do
    it 'registers a callback in both mappings' do
      MockController.on_button_toggle 'space', 'kb', :my_method, :another_method
      MockController.button_down_mapping[Gosu::Button::KbSpace].should_not be_nil
      MockController.button_up_mapping[Gosu::Button::KbSpace].should_not be_nil
    end
  end

  describe "#call_block_or_array" do
    it 'takes a block argument and maps it correctly' do
      called = false
      MockController.new.call_block_or_array -> { called = true }
      called.should be_true
    end

    it 'takes an array argument and maps it correctly' do
      controller = MockControllerWithCallbacks.new
      controller.should_receive(:my_method).with('param')
      controller.call_block_or_array [:my_method, 'param']
    end
  end

  describe "#button_down" do
    it "triggers a method on the class with key as argument" do
      controller = MockControllerWithCallbacks.new
      MockControllerWithCallbacks.on_button_down 'f', 'kb', :my_method
      controller.should_receive(:my_method).with('f')
      controller.button_down(Gosu::Button::KbF)
    end
  end

  describe "#button_up" do
    it "triggers a method on the class with key as argument" do
      controller = MockControllerWithCallbacks.new
      MockControllerWithCallbacks.on_button_up 'g', 'kb', :my_method
      controller.should_receive(:my_method).with('g')
      controller.button_up(Gosu::Button::KbG)
    end
  end

  describe "#update_input" do
    it "runs button_down callbacks while button is held" do
      MockControllerWithCallbacks.instance_variable_set '@button_down_mapping', {}
      MockControllerWithCallbacks.on_button_down 'h', 'kb', :my_method
      controller = MockControllerWithCallbacks.new
      controller.should_receive(:my_method).with('h')
      controller.update_input
    end
  end
end