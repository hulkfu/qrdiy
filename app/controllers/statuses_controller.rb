class StatusesController < ApplicationController
  def index
    @statuses = Status.all
  end
end
