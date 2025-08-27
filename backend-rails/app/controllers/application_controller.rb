class ApplicationController < ActionController::API

  def tasks 
    render json: Task.all
  end
end
