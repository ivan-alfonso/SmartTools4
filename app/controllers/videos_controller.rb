require 'fileutils'

class VideosController < ApplicationController

  include AwsSqsHelper

  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :set_competition

  # GET /videos
  # GET /videos.json
  def index
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    #2nd you retrieve the comment thanks to params[:id]
    @video = Video.find(params[:id])
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create

    @video_object = params[:video][:video_file]    
    @video = Video.new(video_params)
    @video.competition = @competition   
    @video.video_original_filename = @video_object.original_filename.to_s
    @video.video_content_type = @video_object.content_type.to_s

    respond_to do |format|
      if @video.save
        upload_video(@video.id, @video_object)
        send_msg_to_queue(@video.id.to_s)
        format.html { redirect_to @video.competition, success: 'Hemos recibido tu video y lo estamos procesando para que sea publicado. Tan pronto el video quede publicado en la página del concurso te notificaremos por email. Gracias.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video.competition, notice: 'Video modificado correctamente..' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to @competition, notice: 'Video eliminado.' }
      format.json { head :no_content }
    end
  end

  private
    def set_competition
      @competition = Competition.find(params[:competition_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:name_autor, :last_name_autor, :email_autor, :comment, :state, :url_converted_video)
    end

    def upload_video( video_id, video_object )
        
        video_file_name = video_id.to_s + "-" + video_object.original_filename.to_s
        uploaded_video_file = Rails.root.join('public','uploaded-files', video_file_name)
        File.open(uploaded_video_file, 'wb') do |file|
          file.write(video_object.read)
        end        

        video_on_s3 = "original-videos/" + video_file_name
        upload_file_to_aws_s3(uploaded_video_file, video_on_s3)

        FileUtils.rm(uploaded_video_file.to_s)

    end

end