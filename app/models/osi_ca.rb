class OsiCa < ApplicationRecord
  validates :name, :code, :syntax_osi, presence: true, length: { maximum: 255 }
  # validate :validate_code
  validates :limit_value, presence: true, numericality: { only_integer: true, greater_than: 0 }

  private

  def validate_code
    return if Settings.osi_ca_code.include?(code) || code.blank?

    errors.add(:code, :invalid, message: ' not exists!!!')
  end
end
