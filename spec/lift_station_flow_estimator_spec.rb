require 'rails_helper'

describe LiftStationFlowEstimator do
  describe '#perform' do
    let(:lift_station) { FactoryBot.build :lift_station }
    let!(:pump) { FactoryBot.create(:pump_with_telemetry, lift_station:) }

    it 'should not error' do
      expect { LiftStationFlowEstimator.new(lift_station:).perform }.not_to raise_error
    end

    it 'should create a lift station cycle' do
      expect { LiftStationFlowEstimator.new(lift_station:).perform }.to change { LiftStationCycle.count }.by(1)
    end
  end

  describe '#inflow_rate' do
    let(:lift_station) { FactoryBot.create :lift_station }
    let(:initial_pump_state) { lift_station.pump.pump_states.first }
    let(:time) { initial_pump_state.reported_at }

    before { allow_any_instance_of(LiftStation).to receive(:lead_to_off_volume).and_return 2400 }

    let(:pump_state_inactive2) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 120) }
    let(:pump_state_inactive3) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 240) }
    let(:pump_state_active4) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: true, reported_at: time + 360) }
    let(:pump_state_inactive5) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 480) }
    let(:pump_state_inactive6) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 600) }
    let(:pump_state_active7) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: true, reported_at: time + 720) }
    let(:pump_state_inactive8) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 840) }

    it 'should be implemented' do
      expect { LiftStationFlowEstimator.new(lift_station:).inflow_rate }.not_to raise_error(NotImplementedError)
    end

    it 'should calculate the correct inflow rate' do
      # first pump cycle case
      pump_state_inactive2
      pump_state_inactive3
      pump_state_active4
      pump_state_inactive5
      expect(LiftStationFlowEstimator.new(lift_station:).inflow_rate.round(4)).to eq 6.6667

      # rest pump cycle case
      pump_state_inactive6
      pump_state_active7
      pump_state_inactive8
      expect(LiftStationFlowEstimator.new(lift_station:).inflow_rate).to eq 10
    end
  end

  describe '#outflow_rate' do
    let(:lift_station) { FactoryBot.create :lift_station }
    let(:initial_pump_state) { lift_station.pump.pump_states.first }
    let(:time) { initial_pump_state.reported_at }

    before { allow_any_instance_of(LiftStation).to receive(:lead_to_off_volume).and_return 2400 }

    let(:pump_state_inactive2) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 120) }
    let(:pump_state_inactive3) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 240) }
    let(:pump_state_active4) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: true, reported_at: time + 360) }
    let(:pump_state_inactive5) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 480) }

    it 'should be implemented' do
      expect { LiftStationFlowEstimator.new(lift_station:).outflow_rate }.not_to raise_error(NotImplementedError)
    end

    it 'should calculate the correct inflow rate' do
      pump_state_inactive2
      pump_state_inactive3
      pump_state_active4
      pump_state_inactive5
      expect(LiftStationFlowEstimator.new(lift_station:).outflow_rate).to eq 20
    end
  end

  describe '#flow_total' do
    let(:lift_station) { FactoryBot.create :lift_station }
    let(:initial_pump_state) { lift_station.pump.pump_states.first }
    let(:time) { initial_pump_state.reported_at }

    before { allow_any_instance_of(LiftStation).to receive(:lead_to_off_volume).and_return 2400 }

    let(:pump_state_inactive2) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 120) }
    let(:pump_state_inactive3) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 240) }
    let(:pump_state_active4) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: true, reported_at: time + 360) }
    let(:pump_state_inactive5) { FactoryBot.create(:pump_state, pump: lift_station.pump, active: false, reported_at: time + 480) }

    it 'should be implemented' do
      expect { LiftStationFlowEstimator.new(lift_station:).flow_total }.not_to raise_error(NotImplementedError)
    end

    it 'should calculate the correct flow_total' do
      pump_state_inactive2
      pump_state_inactive3
      pump_state_active4
      pump_state_inactive5
      expect(LiftStationFlowEstimator.new(lift_station:).flow_total).to eq 3200
    end
  end
end
