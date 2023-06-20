class VpnManagerController < ApplicationController
  def status
    vpn_manager = OpenVPNManager.new
    @status = vpn_manager.status
  end
end
