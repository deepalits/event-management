# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :user_events
  has_many :users, through: :user_events

  validates :start_datetime, :end_datetime, presence: true

  scope :in_range_of, ->(start_date, end_date) { where('DATE(start_datetime) >= ? AND DATE(end_datetime) <= ?', start_date, end_date) }
end
