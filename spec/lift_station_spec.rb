require 'rails_helper'

describe LiftStation do
  describe '#total_tank_volume' do
    let(:lift_station) { FactoryBot.create :lift_station, radius: 4, height: 10, lead_to_floor: 8.2, off_to_floor: 0.2 }

    it 'is implemented' do
      expect { lift_station.total_tank_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      expect(lift_station.total_tank_volume.round(4)).to eq 502.6548
    end
  end

  describe '#lead_to_off_volume' do
    let(:lift_station) { FactoryBot.create :lift_station, radius: 4, height: 10, lead_to_floor: 8.2, off_to_floor: 0.2 }

    it 'is implemented' do
      expect { lift_station.lead_to_off_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      expect(lift_station.lead_to_off_volume.round(4)).to eq 402.1239
    end
  end
end
