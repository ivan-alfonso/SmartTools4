require 'heroku-api'

class AutoScaligWorker
  
  include AwsSqsHelper

  def perform 
  	
    heroku = Heroku::API.new(:api_key => ENV['API_KEY'])

    numeroMensajesSQS = count_messages_from_queue().to_i

    if ( numeroMensajesSQS == 2 )
	     heroku.post_ps_scale('smarttools4', 'worker', 0)
    end

=begin
    elsif ( numeroMensajesSQS < 5 )
        heroku.post_ps_scale('smarttools4', 'worker', 2)
    end

    elsif ( numeroMensajesSQS < 7 )
        heroku.post_ps_scale('smarttools4', 'worker', 3)
    end

    elsif ( numeroMensajesSQS > 6 )
        heroku.post_ps_scale('smarttools4', 'worker', 4)
    end
=end

  end

end