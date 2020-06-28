class EventsController < ApplicationController
  before_action :events, only: :index
  def index
    @events.order('created_at ASC')
  end

  private

  def events
    if params[:search] && params[:search][:date].present?
      start_date, end_date = params[:search][:date].split(' - ')
      @events = Event.in_range_of(Date.parse(start_date), Date.parse(end_date))
    else
      @events = Event.all
    end
  end

  def event
    @event = Event.find params[:id]
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_datetime, :end_datetime, :id, :date)
  end
end
