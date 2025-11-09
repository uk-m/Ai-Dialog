class WeeklyDigest < ApplicationRecord
  belongs_to :user

  validates :week_of, presence: true
  validates :summary, presence: true

  scope :recent, -> { order(week_of: :desc) }
end
