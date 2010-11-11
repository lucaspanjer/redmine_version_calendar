class VersionCalendarController < ApplicationController
  unloadable

  def index
    @user = User.current     
    
    @today = Date.today
    if params[:year] && params[:week]
      @date = Date.commercial(params[:year].to_i, params[:week].to_i)
    else
      @date = Date.commercial(@today.cwyear, @today.cweek)
    end
    @next_week = @date + 7
    @prev_week = @date - 7
    @start_date = @date - @date.wday - 7
    @end_date = (@next_week - 1) + (6 - (@next_week - 1).wday)


    @versions = load_allowed_versions
#.projects.find(:all, Project.allowed_to_condition(u, :view_issues) ).collect { |p| p.versions }.flatten.select {|v| !v.completed? }

#    @versions = Version.find(:all,
#                             :conditions => ["effective_date <= ?", @end_date],
#                             :order => "#{Version.table_name}.effective_date ASC, #{Version.table_name}.name DESC")

    @versions = @versions.select {|v| !v.completed? } unless params[:completed]
    @versions = @versions.select {|v| !v.effective_date.nil? && v.effective_date >= @start_date && v.effective_date <= @end_date}

    @version_map = Hash.new([])

    @start_date.step(@end_date) do |date|
      @version_map[date] = @versions.select { |v| v.effective_date == date }
    end
  end


  def load_allowed_versions
    @projects = User.current.projects.find(:all, Project.allowed_to_condition(User.current, :view_issues))
    @versions = @projects.collect{|p| p.versions}.flatten.sort { |a,b| a <=> b }
  end

end
