require_relative '../../spec_helper'
 
describe Gamework::Window do
  describe "event delegation" do

    %w(update draw).each do |event|
      it "delegates .#{event} to Gamework::App" do
        Gamework::Window.any_instance.stub(:super)
        Gamework::App.should_receive(event)
        window = Gamework::Window.new(1,2)
        window.send(event)
      end
    end

    %w(button_down button_up).each do |event|
      it "delegates .#{event} to Gamework::App" do
        Gamework::Window.any_instance.stub(:super)
        Gamework::App.should_receive(event).with(1)
        window = Gamework::Window.new(1,2)
        window.send(event, 1)
      end
    end

  end
end