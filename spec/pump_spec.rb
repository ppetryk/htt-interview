require 'rails_helper'

describe Pump do
  context 'when checking whether pump is on/off' do
    let(:pump) { FactoryBot.create :pump }

    context 'it returns the correct value when #on? is called' do
      it 'returns true when #on? is called and the pump is on' do
        FactoryBot.create :pump_state, pump:, active: true
        expect(pump.on?).to eq(true)
      end

      it 'returns false when #on? is called and the pump is off' do
        FactoryBot.create :pump_state, pump:, active: false
        expect(pump.on?).to eq(false)
      end
    end

    context 'it returns the correct value when #on? is called' do
      it 'returns false when #off? is called and the pump is on' do
        FactoryBot.create :pump_state, pump:, active: true
        expect(pump.off?).to eq(false)
      end

      it 'returns true when #off? is called and the pump is off' do
        FactoryBot.create :pump_state, pump:, active: false
        expect(pump.off?).to eq(true)
      end
    end
  end
end
