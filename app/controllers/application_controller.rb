class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :init_notebook, :init_remote_data
  
  private
  
  def init_notebook
    @notebook = THE_NOTEBOOK
  end
  
  def init_remote_data
    @remote_data = THE_REMOTE_DATA
  end
end
