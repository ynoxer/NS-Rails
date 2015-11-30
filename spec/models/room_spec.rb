require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'room is not publishable' do
    let(:room) { create(:room, price: '') }

    describe '#publishable?' do
      it 'returns false' do
        expect(room.publishable?).to be false
      end
    end

    describe '#publish' do
      it 'returns false' do
        expect(room.publish).to be false
      end
    end
  end

  context 'room is publishable' do
    let(:room) { create(:room) }

    describe '#publishable?' do
      it 'returns true' do
        expect(room.publishable?).to be true
      end
    end

    describe '#publish' do
      it 'changes room state to published' do
        expect do
          room.publish
        end.to change { room.type }.from('Draft').to('Published')
      end
    end

    describe '#edit_room' do
      it 'changes the parameters of the room' do
        expect do
          room.edit_room :name => 'name_new', :address => 'address', :price => 'price'
        end.to change { room.name }.from('Name').to('name_new')
      end
    end

    describe '#revoke' do
      context 'state is Published' do
        before { room.publish }

        it 'changes state to Revoked' do
          expect do
            room.revoke
          end.to change { room.type }.from('Published').to('Revoked')
        end
      end

      context 'state is Draft' do
        it 'returns false' do
          expect(room.revoke).to be false
        end
      end
    end

    describe '#expire' do
      context 'room is not passed expiration date' do
        before do
          room.publish
          allow(Time).to receive(:now).and_return(Time.now + (60 * 60 * 24 * 29))
        end

        it 'returns false' do
          expect(room.expire).to be false
        end
      end

      context 'room is passed expiration date' do
        before do
          room.publish
          allow(Time).to receive(:now).and_return(Time.now + (60 * 60 * 24 * 31))
        end

        it 'changes state to Revoked' do
          expect{ room.expire }.to change { room.type }.from('Published').to('Revoked')
        end
      end
    end
  end
end
