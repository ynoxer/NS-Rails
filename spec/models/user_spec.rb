require 'rails_helper'

RSpec.describe User, type: :model do
  context 'user is a host' do
    let(:user) { create(:user, state: 'Host') }

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
    let(:user) { create(:user) }

    describe '#new_room' do
      it 'returns false' do
        expect(user.new_room('room1')).to be false
      end
    end

    describe '#upgrade' do
      it 'changes users state to Host' do
        expect { user.upgrade }.to change { user.state }.from('Free').to('Host')
      end
    end

    describe '#reserve_room' do
      let(:room) { create(:room) }
      before { user.reserve_room(room.id ,'Nov 10', 'Nov 23') }

      context 'room is NOT reserved for the given time period' do
        it 'reserves the given time period' do
          expect(Reservation.find_by(room_id: room.id, from: 'Nov 10'.to_date, to: 'Nov 23'.to_date)).not_to be_nil
        end
      end

      context 'room is reserved for the given time period' do
        it 'returs false' do
          expect(user.reserve_room(1, 'Nov 8', 'Nov 13')).to be false
        end
      end
    end
  end
end
