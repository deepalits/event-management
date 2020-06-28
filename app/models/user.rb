class User < ApplicationRecord
  validates :email, :user_name, presence: true, uniqueness: true
  has_many :contacts
  has_many :user_events
  has_many :events, through: :user_events

  accepts_nested_attributes_for :contacts, allow_destroy: true
end
