# ActiveJob for gathering VPN stats
class GatherVpnStatsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #puts "Gathering VPN stats START at #{Time.now}"
    reschedule_job

    Vpn.all.each do |vpn|
      # puts "VPN: #{vpn.id}, Port: #{vpn.port}, Management: #{vpn.managementPort}"
      mgmt = OpenvpnManager.new( {'Host' => 'localhost', 'Port' => vpn.managementPort.to_i} )
      stats = mgmt.stats
      puts stats
      unless stats.nil?
        vpn_rrd = VPNtoRRD.new vpn.name
        vpn_rrd.update stats[:bytes_download], stats[:bytes_upload], stats[:clients]
      end
      mgmt.destroy
    end
    # puts "Gathering VPN stats END at #{Time.now}"
  end

  def reschedule_job
    # puts "rescheduling at #{Time.now + 2.minutes}"
    self.class.set(wait: 2.minutes).perform_later
  end
end
