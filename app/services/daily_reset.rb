module DailyReset
  def self.perform
    Player.find_each do |player|
      player.update(money: player.money + 10_000)
    end
  end
end
