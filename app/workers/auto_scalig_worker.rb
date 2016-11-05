require 'heroku-api'

class AutoScaligWorker
  
  include AwsSqsHelper

  def perform 
  	
    heroku = Heroku::API.new(:api_key => ENV['API_KEY'])

    numeroMensajesSQS = count_messages_from_queue().to_i

    if ( numeroMensajesSQS == 0 )
       heroku.post_ps_scale('smarttools4', 'worker', 0)
    elsif ( numeroMensajesSQS < 3 )
	     heroku.post_ps_scale('smarttools4', 'worker', 1)
    elsif ( numeroMensajesSQS < 5 )
       heroku.post_ps_scale('smarttools4', 'worker', 2)
    elsif ( numeroMensajesSQS < 7 )
       heroku.post_ps_scale('smarttools4', 'worker', 3)
    elsif ( numeroMensajesSQS >6 )
       heroku.post_ps_scale('smarttools4', 'worker', 4)
    end

  end

end