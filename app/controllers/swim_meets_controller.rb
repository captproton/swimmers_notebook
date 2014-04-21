class SwimMeetsController < ApplicationController
  before_action :set_swim_meet, only: [:show, :edit, :update, :destroy]

  # GET /swim_meets
  # GET /swim_meets.json
  def index
    @swim_meets = SwimMeet.load
  end

  # GET /swim_meets/1
  # GET /swim_meets/1.json
  def show
  end

  # GET /swim_meets/new
  def new
    @swim_meet = SwimMeet.new
  end

  # GET /swim_meets/1/edit
  def edit
  end

  # POST /swim_meets
  # POST /swim_meets.json
  def create
    @swim_meet = SwimMeet.new(swim_meet_params)

    respond_to do |format|
      if @swim_meet.save
        format.html { redirect_to @swim_meet, notice: 'Swim meet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @swim_meet }
      else
        format.html { render action: 'new' }
        format.json { render json: @swim_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /swim_meets/1
  # PATCH/PUT /swim_meets/1.json
  def update
    respond_to do |format|
      if @swim_meet.update(swim_meet_params)
        format.html { redirect_to @swim_meet, notice: 'Swim meet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @swim_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /swim_meets/1
  # DELETE /swim_meets/1.json
  def destroy
    @swim_meet.destroy
    respond_to do |format|
      format.html { redirect_to swim_meets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_swim_meet
      @swim_meet = SwimMeet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def swim_meet_params
      params.require(:swim_meet).permit(:title, :started_on, :finished_on, :courses, :location, :location_url, :results_url)
    end
end
