require 'rails_helper'

describe PumpCycle do
  context 'when pump_states are created' do
    let(:lift_station) { FactoryBot.create :lift_station }
    let(:pump) { lift_station.pump } # pump defaults to off

    it 'starts a new cycle when the pump was off and is now on' do
      expect { FactoryBot.create :pump_state, pump:, active: true }.to change { PumpCycle.for_pump(pump).count }.by(1)
    end

    it 'ends a cycle when the pump was on and is now off' do
      FactoryBot.create :pump_state, pump:, active: true # turn pump on
      FactoryBot.create :pump_state, pump:, active: false # trun pump off

      expect(PumpCycle.for_pump(pump).last.ended?).to be_truthy
    end

    it 'sets the correct duration and create lift station cycle when a pump cycle ends' do
      time = Time.now
      FactoryBot.create :pump_state, pump:, active: true, reported_at: (time - 120.seconds)

      expect do
        FactoryBot.create :pump_state, pump:, active: false, reported_at: time
      end.to change {
               PumpCycle.for_pump(pump).last.duration
             }.to(120)
      expect(lift_station.lift_station_cycles.size).to eq 1
    end
  end
end
