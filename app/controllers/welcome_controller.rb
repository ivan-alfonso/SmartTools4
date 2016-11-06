require 'resolv'
require 'socket'

class WelcomeController < ApplicationController 
  def index
  	@host = Resolv.getname(request.remote_ip)
  	@hostsocket = Socket.gethostname

  	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@iptest = ip.ip_address
  end
end
