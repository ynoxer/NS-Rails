require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user is a host' do
    let(:user) { create(:user, type: 'Host') }

    describe '#upgrade' do
      it 'returns false' do
        expect(user.upgrade).to be false
      end
    end

    describe '#new_room' do
      before { user.new_room('room') }

      it 'creates instance of room with the caller as the owner' do
        expect(Room.find(1).user_id).to eq(user.id)
      end
    end
  end

  context 'user is not a host' do
    let(:user) { create(:user, name: 'name1') }

    describe '#new_room' do
      it 'returns false' do
        expect(user.new_room('room1')).to be false
      end
    end

    describe '#upgrade' do
      it 'changes users type to Host' do
        expect { user.upgrade }.to change { user.type }.from('Free').to('Host')
      end
    end
  end
end
