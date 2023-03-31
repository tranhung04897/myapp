class TrackingHistory < ApplicationRecord
  belongs_to :user
  has_many :tracking_history_details

  delegate :username, to: :user, prefix: :user, allow_nil: true

end
