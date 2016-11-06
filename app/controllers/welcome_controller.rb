require 'resolv'
require 'socket'

class WelcomeController < ApplicationController 
  def index
  	@host = Resolv.getname(request.remote_ip)
  	@hostsocket = Socket.gethostname
  end
end
