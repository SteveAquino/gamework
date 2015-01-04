require_relative '../../../spec_helper'

describe Gamework::MovementTrait do
  before(:each) do
    class Ball < Gamework::Actor::Base
      trait 'gamework::movement'
    end
  end

  after(:each) { Object.send(:remove_const, :Ball) }

  let(:ball) { Ball.new }

  describe "#initialize_movement" do
    it "is called on #initialize" do
      expect(ball.instance_variable_get "@speed").to eq(3)
      expect(ball.instance_variable_get "@animated").to be_false
      expect(ball.instance_variable_get "@animating").to be_false
      expect(ball.instance_variable_get "@direction").to eq(:down)
      expect(ball.solid?).to be_true
      expect(ball.movement_options).to eq({})
    end
  end

  describe "#update_movement" do
    it "calls #update_auto_movement if a movement type is set" do
      ball.movement_options[:type] = 'random'
      expect(ball).to receive(:update_auto_movement)
      ball.update_movement
    end

    it "doesn't call #update_auto_movement if a movement type is not set" do
      expect(ball).to_not receive(:update_auto_movement)
      ball.update_movement
    end

    it "is called on #update" do
      ball.movement_options[:type] = 'random'
      expect(ball).to receive(:update_auto_movement)
      ball.update
    end
  end
end
