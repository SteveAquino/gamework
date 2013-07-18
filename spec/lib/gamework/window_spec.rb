require_relative '../../spec_helper'
 
describe Gamework::Window do
	it "has Width and Height set" do
		Gamework::Window::Width.should_not be_nil
		Gamework::Window::Height.should_not be_nil
	end

	describe "#update" do
		it "triggers Scene.update" do
			Gamework::Window.any_instance.stub(:initialize)
			Gamework::Scene.stub(:update) { @called = true }
			@called = false
			window  = Gamework::Window.new
			scene   = Gamework::Scene.new
			2.times { Gamework::Scene.new }
			window.update
			@called.should be_true
		end
	end
end