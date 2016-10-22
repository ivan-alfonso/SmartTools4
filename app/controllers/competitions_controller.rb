class CompetitionsController < ApplicationController

  include UtilitiesHelper

  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!, except: [:show, :index]

  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all
    #@competitions_filter = Competition.where(" user_id = ? ",current_user.id).paginate(page: params[:page],per_page:10)
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    #@video = Video.new
    #@competition_videos = Competition.find(params[:id]).videos.order(created_at: :desc).paginate(page: params[:page],per_page:50)
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    #@competition = current_user.competitions.new(competition_params)
    #startAnio = params["competition"]["dateStart(1i)"]
    #startMes  = params["competition"]["dateStart(2i)"]
    #startDia  = params["competition"]["dateStart(3i)"]

    #endAnio = params["competition"]["dateEnd(1i)"]
    #endMes  = params["competition"]["dateEnd(2i)"]
    #endDia  = params["competition"]["dateEnd(3i)"]

    @competition = Competition.new(competition_params)
    @competition.dateStart = build_date_from_params(params, 'competition', 'dateStart')
    @competition.dateEnd = build_date_from_params(params, 'competition', 'dateEnd')

    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, success: 'Concurso creado correctamente.' }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to @competition, success: 'Concurso modificado correctamente.' }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to competitions_url, success: 'Concurso eliminado.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:name, :url, :dateStart, :dateEnd, :prize)
    end
end
