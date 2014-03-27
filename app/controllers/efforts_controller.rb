class EffortsController < ApplicationController
  def new
    @effort = @notebook.new_effort
  end
  
  def create
    @effort = @notebook.new_effort(effort_params)
    if @effort.publish
      redirect_to root_path, notice: "Effort added!"
    else
      render "new"
    end
  end
  
  private
  
  def effort_params
    params.require(:effort).permit(:name, :age)
  end
  
end
