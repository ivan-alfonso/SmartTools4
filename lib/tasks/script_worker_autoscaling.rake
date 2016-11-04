desc "Tarea AutoScaling Worker"
task :script_worker_autoscaling => :environment do

  #scheduler = Rufus::Scheduler.new
  #scheduler.every '1m', :allow_overlapping => false do
  	puts "Verificando AutoScaling del worker"
  	AutoScaligWorker.new.perform
  	puts "Worker AutoScaling Verificado."
  #end
  #scheduler.join

end
