class VpnManagerController < ApplicationController
  def status
    vpn_manager = OpenvpnManager.new
    @status = vpn_manager.status
  end
end
