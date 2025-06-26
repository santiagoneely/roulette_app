class RouletteRoundJob < ApplicationJob
  queue_as :default

  def perform
    RouletteRoundService.play!
  end
end
