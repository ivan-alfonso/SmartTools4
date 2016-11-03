class VideoConvertedMailer < ApplicationMailer

  #def notify (video)
  def notify (video)
    @video = video

    Rails.logger.info("video #{Time.now} " + video.email_autor)    
    mail to: video.email_autor, subject: 'SmartTools 4.0: Has participado en un concurso'
  end
end
