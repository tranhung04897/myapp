class OsiBooker < ApplicationRecord
  validates :name, :code, :syntax_osi, presence: true, length: { maximum: 255 }
  # validate :validate_code

  private

  def validate_code
    return if Settings.osi_booker_code.include?(code) || code.blank?

    errors.add(:code, :invalid, message: ' not exists!!!')
  end
end
