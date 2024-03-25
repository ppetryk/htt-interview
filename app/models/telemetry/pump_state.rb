# Telemetry data sent from a lift station reports the state of the pump (on/off).
# The station reports every two minutes.
# The state of the pump does not necessarily change each time the station reports.
#
# For the sake of the assignment, assume the pump state did not change between reports, rather the
# the pump switched on/off exactly when the telemtry message was sent. (e.g. pump runs for 6 minutes)
class Telemetry::PumpState < ApplicationRecord
  self.table_name = 'pump_states'
  belongs_to :pump

  before_create :evaluate_pump_cycle

  scope :older_than, ->(time) { where('reported_at < ?', time) }

  # TODO: implement method
  # when the pump was off and it switches on, start a PumpCycle
  # when the pump was on and it switches off, end a PumpCycle and include its duration
  def evaluate_pump_cycle
    # raise NotImplementedError, 'This method still needs to be implemented.'
  end
end
