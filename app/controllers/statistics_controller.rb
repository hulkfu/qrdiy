class StatisticsController < ApplicationController

  def index
    authorize Statistic
  end
end
