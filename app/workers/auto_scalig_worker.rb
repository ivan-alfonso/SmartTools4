require 'heroku-api'

class AutoScaligWorker
  
  include AwsSqsHelper

  def perform 
  	
#  	HEROKU_API_KEY = ENV['API_KEY']
	heroku = Heroku::API.new(:api_key => ENV['API_KEY'])

	heroku.post_ps_scale('smarttools4', 'worker', 2)

=begin
	q = queued_events_count.to_i
	if q > 2000
  	
  		if workers_count < 20
    	# increase workers to 20 when the queue is very large
    	heroku.post_ps_scale(APP, 'worker', 20)
    	# Do other stuff, such as notify PagerDuty
  		end
	
	elsif (q <= 2000 && q > 1000)
  		
  		if workers_count != 12
  		# If workers are less than or greater than 12, scale them to 12
  		heroku.post_ps_scale(APP, 'worker', 12)
  		end
	
	#elsif ...
	#end
=end

  end

end