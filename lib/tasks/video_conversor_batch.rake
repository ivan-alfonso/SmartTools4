desc "Tarea que convierte los videos subidos a mp4"
task :video_conversor_batch => :environment do
  puts "Convirtiendo video a mp4"
  VideoConversionWorker.new.perform
  puts "Video convertido."
end