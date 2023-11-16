class Sabeel < ApplicationRecord
  # * Associations
  has_many :thaalis, dependent: :destroy
  has_many :transactions, through: :thaalis

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables
    [its]
  end

  # * RANSACK
  include Ransackable
  RANSACK_ATTRIBUTES = %w[name]
  RANSACK_ASSOCIATIONS = %w[thaalis]

  include ITSValidation
  include NameValidation

  # * Enums
  enum :apartment, APARTMENTS

  # * Scopes
  scope :no_thaali, -> { where.missing(:thaalis) }

  scope :not_taking_thaali, -> { no_thaali.union(took_thaali) }

  scope :not_taking_thaali_in, ->(apartment) { where(apartment:).not_taking_thaali.order(flat_no: :asc) }

  scope :taking_thaali, -> { thaalis.where(thaalis: {year: CURR_YR}).order(flat_no: :asc) }

  scope :taking_thaali_in_year, ->(year) { thaalis.where(thaalis: {year:}) }

  scope :thaalis, -> { joins(:thaalis) }

  scope :took_thaali, -> { thaalis.group("sabeels.id").having("MAX(thaalis.year) < #{CURR_YR}") }

  scope :with_thaali_size, ->(size) { thaalis.where(thaalis: {size:}) }

  # * Validations
  validates :apartment, presence: true
  validates_email_format_of :email, allow_blank: true
  validates :flat_no, numericality: {only_integer: true, greater_than: 0}
  validates :mobile, numericality: {only_integer: true}, length: {is: 10}

  # * Methods
  def address
    "#{apartment.titleize} #{flat_no}"
  end

  def taking_thaali?
    Rails.cache.fetch("sabeel_#{id}_taking_thaali?") { thaalis.exists? year: CURR_YR }
  end

  def took_thaali?
    Rails.cache.fetch("sabeel_#{id}_took_thaali?") { thaalis.exists? year: PREV_YR }
  end

  def last_year_thaali_dues_cleared?
    thaalis.dues_cleared_in(PREV_YR).present?
  end
end
