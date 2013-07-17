require_relative '../../spec_helper'
 
describe Gamework::Window do
	it "is an instance of GosuWindow" do
		window = Gamework::Window.new
		window.is_a?(Gosu::Window).should be_true
	end
end