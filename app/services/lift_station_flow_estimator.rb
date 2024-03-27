# calculates estimates for the
#  -inflow rate
#  - flow rate
#  - flow total
# and creates a new LiftStationCycle to record the data
class LiftStationFlowEstimator
  def initialize(lift_station:)
    @lift_station = lift_station
  end

  # calculate the values and create a new LiftStationCycle to record
  def perform
    @lift_station.lift_station_cycles.create(inflow_rate:, outflow_rate:, flow_total:)
  end

  # represents the rate of liquid flow into a lift station tank
  def inflow_rate
    @lift_station.lead_to_off_volume / inflow_duration
  end

  # the total amount of liquid pumped out of the tank
  # NOTE: this should include the amount of liquid that flowed into the tank
  #       while the pump ran because water does not stop flowing into the tank
  #       while the pump is on
  # use the most recent inflow rate as an estimate
  def flow_total
    @lift_station.lead_to_off_volume + inflow_rate * latest_pump_cycle.duration
  end

  # represents the rate of liquid pumped out of the tank
  def outflow_rate
    @lift_station.lead_to_off_volume / latest_pump_cycle.duration
  end

  # calculates as the difference between
  # the pump cycle start date and the initial pump state report date for the first pump cycle
  # and between the pump cycle start date and the previous pump cycle end date for the rest
  def inflow_duration
    inflow_start_date = prev_pump_cycle ? prev_pump_cycle.ended_at : initial_pump_state.reported_at
    latest_pump_cycle.started_at - inflow_start_date
  end

  protected

  def initial_pump_state
    @lift_station.pump.pump_states.first
  end

  def prev_pump_cycle
    pump_cycles.size > 1 ? pump_cycles.last : nil
  end

  def latest_pump_cycle
    pump_cycles.first
  end

  def pump_cycles
    @pump_cycles ||= PumpCycle.recent_finished(@lift_station.pump)
  end
end
