class MonitoringController < ApplicationController
  def index
    status
    render
  end

  # TODO
  def show
    render
  end

  # TODO
  def get_rrd

  end

  # TODO
  def set_rrd

  end

  private

  def status
    vpn_manager = OpenvpnManager.new 'Host': 'localhost', 'Port': 7505
    @status = vpn_manager.status
  end
end
