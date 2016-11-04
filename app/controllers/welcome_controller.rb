class WelcomeController < ApplicationController
  include AwsSqsHelper
  
  def index
  	@NumeroMensajesSQS = count_messages_from_queue()
  end
end
