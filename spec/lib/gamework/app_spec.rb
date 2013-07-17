require_relative '../../spec_helper'
 
describe Gamework::App do
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