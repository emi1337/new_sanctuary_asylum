class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_primary_community
  before_action :require_access_to_community

  def index
    week1, week2 = DatesHelper.two_weeks

    if activities_listed_next_month?(week1, week2)
      unless flash[:success]
        flash[:success] = "Accompaniments posted for next month! Click 'Next' in the calendar to view future accompaniments."
      end
    end
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(week1.begin, week2.end)
                                         .includes(:accompaniments, :users, :friend, :location)
  end

  private

  def activities_listed_next_month?(week1, week2)
    week1.begin.month != week2.end.month &&
    current_region.activities.for_time_confirmed(week2.begin.beginning_of_month, week2.end).any?
  end
end
