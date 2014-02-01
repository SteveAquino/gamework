require_relative '../../../spec_helper'

describe Gamework::MovementTrait do
  before(:each) do
    class Ball < Gamework::Drawable
      trait 'gamework::movement'
    end
  end

  after(:each) { Object.send(:remove_const, :Ball) }

  let(:ball) { Ball.new }

  describe "#initialize_movement" do
    it "is called on initialize" do
      expect(ball.instance_variable_get "@speed").to eq(3)
      expect(ball.instance_variable_get "@animated").to be_false
      expect(ball.instance_variable_get "@animating").to be_false
      expect(ball.instance_variable_get "@direction").to eq(:down)
      expect(ball.solid?).to be_true
    end
  end
end