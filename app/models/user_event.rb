class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum rsvp: { maybe: 0, yes: 1, no: 2 }

  delegate :name, to: :user
end
