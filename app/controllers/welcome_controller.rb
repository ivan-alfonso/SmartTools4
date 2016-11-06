require 'resolv'

class WelcomeController < ApplicationController 
  def index
  	@host = Resolv.getname(request.remote_ip)
  end
end
