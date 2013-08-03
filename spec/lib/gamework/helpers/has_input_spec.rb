require_relative '../../../spec_helper'
 
describe Gamework::HasAssets do
  describe ".on_button_down" do
    it 'registers a callback for a given button id' do
      class Controller
        include Gamework::HasInput
      end
      Controller.on_button_down 'a' do
        puts 'hi'
      end
      Controller.new.button_down('a')
    end
  end

  describe ".gosu_button_id" do
    it 'maps strings to a Gosu::Button constant' do
      class Controller
        include Gamework::HasInput
      end
      Controller.gosu_button_id('a', 'kb').should eq Gosu::Button::KbA
    end
  end
end