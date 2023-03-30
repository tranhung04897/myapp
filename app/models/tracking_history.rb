class TrackingHistory < ApplicationRecord
  belongs_to :user
  has_many :tracking_history_details
end
