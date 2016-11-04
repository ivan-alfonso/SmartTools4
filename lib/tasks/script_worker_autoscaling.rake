desc "Tarea AutoScaling Worker"
task :script_worker_autoscaling => :environment do
  puts "Verificando AutoScaling del worker"
  AutoScaligWorker.new.perform
  puts "Worker AutoScaling Verificado."
end
