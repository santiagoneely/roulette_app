class Player < ApplicationRecord
  has_many :bets

  default_scope { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil).where("money > 0") }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def self.with_deleted
    unscope(where: :deleted_at)
  end

  def self.only_deleted
    unscoped.where.not(deleted_at: nil)
  end
end
