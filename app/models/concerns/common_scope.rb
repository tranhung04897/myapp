module CommonScope
  extend ActiveSupport::Concern

  included do
    scope :created_at_desc, -> { order(created_at: :desc) }
  end
end
