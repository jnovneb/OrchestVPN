class VpnManagerController < ApplicationController
  def status
    vpn_manager = OpenvpnManager.new Host: 'localhost', Port: 7505
    @status = vpn_manager.status
  end
end
