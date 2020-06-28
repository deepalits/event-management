class UserEventsController < ApplicationController

  def index
  end
  private

  def user_event_params
    params.permit(:rsvp, :event_id, :user_id, :id)
  end
end
