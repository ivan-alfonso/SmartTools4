require 'resolv'
require 'socket'

class WelcomeController < ApplicationController 
  def index
  	@host = Resolv.getname(request.remote_ip)
  	@hostsocket = Socket.gethostname

  	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@iptest = ip.ip_address


@sock1 = socket.ip_address_list.detect{|intf| intf.ipv4_loopback?}



@sock2 = socket.ip_address_list.detect{|intf| intf.ipv4_private?}



@sock3 = socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}


  end
end
