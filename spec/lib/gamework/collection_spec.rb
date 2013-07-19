require_relative '../../spec_helper'
 
describe Gamework::Collection do
	describe ".all" do
		it "returns all objects as an array" do
			class MockClass
				include Gamework::Collection
			end
			MockClass.all.should eq([])
		end		
	end

	describe "Enumberable methods" do
		it "are available to new classes" do
			class MockClass
				include Gamework::Collection
			end
			%w(all first count select map).each do |method|
				MockClass.respond_to?(method).should be_true
			end
		end

		it "are available to subclasses" do
			class MockClass
				include Gamework::Collection
			end
			class MockSubClass < MockClass
			end
			%w(all first count select map).each do |method|
				MockSubClass.respond_to?(method).should be_true
			end
		end
	end

	describe ".create" do
		it "appends objects to the collection" do
			class MockClass
				include Gamework::Collection
			end
			mock = MockClass.create
			MockClass.all.should eq([mock])
		end		

		it "appends classes to their own collection" do
			class Mock1
				include Gamework::Collection
			end
			class Mock2
				include Gamework::Collection
			end
			mock1 = Mock1.create
			mock2 = Mock2.create
			Mock1.all.should eq([mock1])
			Mock2.all.should eq([mock2])
		end

		it "takes subclassed arguments" do
			class MockClass
				include Gamework::Collection
				attr_reader :args
				def initialize(*args)
					@args = *args
				end
			end

			mock = MockClass.create('a', 'b', 'c')
			mock.args.should eq(['a', 'b', 'c'])
		end
	end

	describe ".last" do
		it "returns the last object in the collection" do
			class MockClass
				include Gamework::Collection
			end
			5.times { MockClass.create }
			mock = MockClass.create
			MockClass.last.should eq(mock)
		end
	end

	describe ".shift" do
		it "removes an object from the collection and returns it" do
			class MockClass
				include Gamework::Collection
			end

			mock = MockClass.create
			5.times { MockClass.create }
			
			MockClass.shift.should eq(mock)
			MockClass.count.should eq(5)
		end
	end
end