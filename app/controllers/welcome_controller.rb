class WelcomeController < ApplicationController
  include UtilitiesHelper
  
  def index
  	@NumeroMensajesSQS = count_messages_from_queue()
  end
end
