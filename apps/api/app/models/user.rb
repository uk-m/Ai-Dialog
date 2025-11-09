class User < ApplicationRecord
  extend Devise::Models

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :diary_entries, dependent: :destroy
  has_many :weekly_digests, dependent: :destroy

  store_accessor :preferences, :language, :theme, :week_start

  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :time_zone, presence: true

  def display_name
    name.presence || email.split("@").first
  end
end
