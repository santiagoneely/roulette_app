class RouletteRoundJob < ApplicationJob
  queue_as :default

  def perform
     Rails.logger.info ">>> Ejecutando RouletteRoundJob en #{Time.current}"
    RouletteRoundService.perform
  end
end
