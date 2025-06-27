class RoundsController < ApplicationController
  def index
    @rounds = Round.order(created_at: :desc).includes(bets: :player).limit(50)
  end

  def show
    @round = Round.includes(bets: :player).find(params[:id])
  end

  def play
    RouletteRoundService.perform
    redirect_to rounds_path
  end
end
