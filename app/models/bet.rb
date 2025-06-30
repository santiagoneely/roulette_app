class Bet < ApplicationRecord
  belongs_to :player, -> { Player.with_deleted }
  belongs_to :round
end
