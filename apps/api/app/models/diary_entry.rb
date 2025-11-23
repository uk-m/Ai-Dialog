class DiaryEntry < ApplicationRecord
  MOODS = %w[happy excited calm neutral tired sad frustrated grateful].freeze
  STATUSES = {
    draft: "draft",
    published: "published"
  }.freeze

  belongs_to :user
  has_many :diary_entry_tags, dependent: :destroy
  has_many :tags, through: :diary_entry_tags

  has_many_attached :photos
  validate :photos_must_be_images

  enum :status, STATUSES

  validates :title, presence: true, length: { maximum: 120 }
  validates :body, length: { maximum: 10_000 }, allow_blank: true
  validates :mood, inclusion: { in: MOODS }, allow_blank: true
  validates :journal_date, presence: true

  before_validation :set_defaults

  scope :recent, -> { order(journal_date: :desc, created_at: :desc) }
  scope :published, -> { where(status: "published") }

  def publish!
    update!(status: "published", published_at: Time.current)
  end

  def tag_names=(names)
    return if names.nil?

    self.tags = names.filter_map do |name|
      next if name.blank?

      Tag.find_or_create_by!(name: name.strip)
    end
  end

  def tag_names
    tags.pluck(:name)
  end

  private

  def set_defaults
    self.journal_date ||= Date.current
  end

  def photos_must_be_images
    return unless photos.attached?

    photos.each do |photo|
      next if photo.content_type&.match?(%r{\Aimage/})

      errors.add(:photos, "must be an image")
    end
  end
end
