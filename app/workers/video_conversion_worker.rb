require 'fileutils'

class VideoConversionWorker
  
  include AwsSqsHelper

  def perform 

    message_from_queue = obtain_message_from_queue[0]

    if message_from_queue

      # Searching the video
      video = Video.find(message_from_queue.body)

      if video && video.state == "En proceso"

         folderconverted = "converted-videos"
         folderVideoOriginal = "original-videos"
         path_videoOriginal = Rails.root.join("public", folderVideoOriginal)

         unless Dir.exist?(path_videoOriginal)
            FileUtils.mkdir_p(path_videoOriginal)
         end

         original_video_name = video.id.to_s + "-" + video.video_original_filename.to_s
         downloadVideo = folderVideoOriginal + "/" + original_video_name
         videoToConvert = path_videoOriginal.to_s + "/" + original_video_name
         download_file_from_aws_s3(downloadVideo, videoToConvert)

         path_videoConvertido = Rails.root.join("public", folderconverted)
         video_name_without_ext = File.basename(videoToConvert, File.extname(videoToConvert))
         converted_video_name = video_name_without_ext + ".mp4"
         videoConvertido = path_videoConvertido.to_s + "/" + converted_video_name

         unless Dir.exist?(path_videoConvertido)
            FileUtils.mkdir_p(path_videoConvertido)
         end

         unless File.exist?(videoConvertido)
            
            movie = FFMPEG::Movie.new(videoToConvert.to_s)
            movie.transcode(videoConvertido)
            
            video_on_s3 = folderconverted + "/" + converted_video_name
            video_on_cloud_front = upload_file_to_aws_s3(videoConvertido, video_on_s3)

            video.update_attributes(state: 'Procesado', url_converted_video: video_on_cloud_front.to_s)
            delete_message_from_queue(message_from_queue.receipt_handle)
            VideoConvertedMailer.notify(video).deliver

            FileUtils.rm(videoToConvert.to_s)
            FileUtils.rm(videoConvertido.to_s)

          end

        end

      end

  end

end
