require 'fileutils'

class CompetitionsController < ApplicationController

  include UtilitiesHelper

  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!, except: [:show, :index]

  # GET /competitions
  # GET /competitions.json
  def index
    if !session[:user_id]
       redirect_to init_session_path
    end  
    @competitions = Competition.where(:user_id => session[:user_id]).all
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    @video = Video.new
    @competition_videos = Competition.find(params[:id]).videos
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
    
    @image_object = params[:competition][:image_file]
    @competition = Competition.new(competition_params)
    @competition.user_id = session[:user_id]    
    @competition.image_original_filename = @image_object.original_filename.to_s
    @competition.image_content_type = @image_object.content_type.to_s

    respond_to do |format|
      if @competition.save
        upload_file(@competition.id, @image_object, "images")
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
      if @competition.update_attributes(competition_params)
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

      paramsHASH = params.require(:competition).permit(:name, :url, :dateStart, :dateEnd, :prize, :user_id)
      dateStart = build_date_from_hash(paramsHASH, "dateStart")
      dateEnd = build_date_from_hash(paramsHASH, "dateEnd")
      paramsHASH.reject! {|key, value| key == "dateStart(1i)"}
      paramsHASH.reject! {|key, value| key == "dateStart(2i)"}
      paramsHASH.reject! {|key, value| key == "dateStart(3i)"}
      paramsHASH.reject! {|key, value| key == "dateEnd(1i)"}
      paramsHASH.reject! {|key, value| key == "dateEnd(2i)"}
      paramsHASH.reject! {|key, value| key == "dateEnd(3i)"}
      paramsHASH["dateStart"] = dateStart
      paramsHASH["dateEnd"] = dateEnd

      return paramsHASH

    end
    
end
