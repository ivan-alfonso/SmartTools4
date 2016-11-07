require 'fileutils'

class VideoConversionWorker
  
  include AwsSqsHelper

  def perform 

    message_from_queue = obtain_message_from_queue[0]

    while (message_from_queue) do

    #if message_from_queue

      # Searching the video
      video = Video.find(message_from_queue.body)

      if video && video.state == "En proceso"

         folder_converted_videos = "converted-videos"
         folder_original_videos = "original-videos"
         path_original_videos = Rails.root.join("public", folder_original_videos)

         unless Dir.exist?(path_original_videos)
            FileUtils.mkdir_p(path_original_videos)
         end

         original_video_name = video.id.to_s + "-" + video.video_original_filename.to_s
         downloaded_video_from_s3 = folder_original_videos + "/" + original_video_name
         video_to_convert = path_original_videos.to_s + "/" + original_video_name
         download_file_from_aws_s3(downloaded_video_from_s3, video_to_convert)

         path_converted_videos = Rails.root.join("public", folder_converted_videos)
         video_name_without_ext = File.basename(video_to_convert, File.extname(video_to_convert))
         converted_video_name = video_name_without_ext + ".mp4"
         converted_video = path_converted_videos.to_s + "/" + converted_video_name

         unless Dir.exist?(path_converted_videos)
            FileUtils.mkdir_p(path_converted_videos)
         end

         unless File.exist?(converted_video)
            
            movie = FFMPEG::Movie.new(video_to_convert.to_s)
            movie.transcode(converted_video)
            
            video_on_s3 = folder_converted_videos + "/" + converted_video_name
            video_on_cloud_front = upload_file_to_aws_s3(converted_video, video_on_s3)

            video.update_attributes(state: 'Procesado', url_converted_video: video_on_cloud_front.to_s)
            delete_message_from_queue(message_from_queue.receipt_handle)
            VideoConvertedMailer.notify(video).deliver

            FileUtils.rm(video_to_convert.to_s)
            FileUtils.rm(converted_video.to_s)

          end

        end

        message_from_queue = obtain_message_from_queue[0]
      end

  end

end
