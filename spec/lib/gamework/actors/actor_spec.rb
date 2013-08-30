require_relative '../../../spec_helper'
 
describe Gamework::Actor do
  describe ".new" do
    it 'creates an Actor from a hash of options' do
      actor = Gamework::Actor.new 'spritesheet.png', position: [400, 320]
      actor.width.should eq(30)
      actor.height.should eq(30)
      actor.x.should eq(400)
      actor.y.should eq(320)
    end
  end

  describe '.step' do
    it 'moves over a given distance' do
      Gamework::Sprite.any_instance.stub(:make_sprites)
      actor = Gamework::Actor.new 'spritesheet.png', position: [400, 320]
      actor.step(32)
      sleep 2
      actor.y.should eq(353)
    end
  end

  describe '.random_movement' do
    it 'moves in a random direction' do
      actor = Gamework::Actor.new 'spritesheet.png', position: [400, 320]
      actor.stub(:step)
      actor.stub(:rand).and_return(1)
      actor.should_receive(:turn).with(:down)
      actor.should_receive(:step).with(10)
      actor.random_movement(10, 0)
    end
  end

  describe '.update_auto_movement' do
    context 'without delay' do
      it 'only updates when not moving' do
        actor = Gamework::Actor.new 'spritesheet.png', position: [400, 320], movement: {type: 'random'}
        actor.stub(:step)
        actor.stub(:rand).and_return(1)
        actor.should_receive(:random_movement).twice

        actor.update_auto_movement
        sleep 0.9
        actor.update_auto_movement
        sleep 0.1
        actor.update_auto_movement
      end
    end

    context 'with delay' do
      it 'waits a given interval before updating' do
        actor = Gamework::Actor.new 'spritesheet.png', position: [400, 320], movement: {type: 'random', delay: 2}
        actor.stub(:step)
        actor.stub(:rand).and_return(1)
        actor.should_receive(:random_movement).exactly(3).times

        actor.update_auto_movement
        sleep 1
        actor.update_auto_movement
        sleep 0.9
        actor.update_auto_movement
        sleep 0.1
        actor.update_auto_movement
      end
    end
  end

end