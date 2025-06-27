class DailyResetJob < ApplicationJob
  queue_as :default

  def perform
    DailyReset.perform
  end
end
