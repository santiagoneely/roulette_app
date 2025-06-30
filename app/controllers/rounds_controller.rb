class RoundsController < ApplicationController
  include Pagy::Backend
  def index
    @pagy, @rounds = pagy(Round.order(created_at: :desc).includes(bets: :player))
  end

  def show
    @round = Round.includes(bets: :player).find(params[:id])
  end

  def play
    RouletteRoundService.perform
    redirect_to rounds_path
  end
end
