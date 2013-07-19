require_relative '../../../spec_helper'
 
describe Gamework::Scene do
	describe ".update" do
		it "delegates #update to the first Scene in the collection" do
			scene = Gamework::Scene.first || Gamework::Scene.create
			scene.should_receive(:update)
			Gamework::Scene.update
		end

		it "destroys the scene on the next update" do
			scene = Gamework::Scene.first || Gamework::Scene.create
			scene.end_scene
			expect { Gamework::Scene.update }.to change { Gamework::Scene.count }.by(-1)
		end

		xit "continues to the next Scene for updating" do
			2.times { Gamework::Scene.create }
			first      = Gamework::Scene.first
			next_scene = Gamework::Scene.all[1]

			first.end_scene
			Gamework::Scene.update
			next_scene.should_receive(:update)
		end
	end

	describe ".draw" do
		it "delegates #draw to the first Scene in the collection" do
			scene = Gamework::Scene.first || Gamework::Scene.create
			scene.should_receive(:draw)
			Gamework::Scene.draw
		end
	end

	describe ".next" do
		it "marks the current Scene for deletion" do
			2.times { Gamework::Scene.create }
			first      = Gamework::Scene.first
			next_scene = Gamework::Scene.all[1]

			Gamework::Scene.next
			first.ended?.should be_true
		end
	end

	describe "#end_scene" do
		it "marks the Scene for deletion" do
			scene = Gamework::Scene.create
			scene.end_scene
			scene.ended?.should be_true
		end
	end
end