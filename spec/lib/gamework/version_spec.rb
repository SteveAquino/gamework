require_relative '../../spec_helper'
 
describe Gamework do
 	
 	describe "VERSION" do
	  it "must be defined" do
	    Gamework::VERSION.should_not be_nil
	  end
 	end
 	
end