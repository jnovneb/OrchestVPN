require 'rrd'

# Class to act as a interface between the VPN and the RRD files
class VPNtoRRD
  def initialize(vpn)
    @vpn = vpn.to_s
    @vpn_file = "#{Rails.root.join('vpn_files','rrd')}#{vpn}.rrd"
    @vpn_rrd  = RRD::Base.new(@vpn_file)
  end

  def update(bytes_in, bytes_out, clients)
    create unless File.exist? @vpn_file
    @vpn_rrd.update Time.now, bytes_in, bytes_out, clients
  end

  def graph
    # Local variable to avoid problems with the instance variable in module RRD
    rrd_file = @vpn_file
    RRD.graph "#{@vpn}-trf.png",
              title: 'VPN traffic',
              width: 800, height: 250,
              color: ['FONT#000000', 'BACK#FFFFFF'] do
      line rrd_file,
           bytes_in: :average,
           color: '#FF0000',
           label: 'Bytes IN', legend: 'Bytes IN',
           width: 1
      line rrd_file,
           bytes_out: :average,
           color: '#00FF00',
           label: 'Bytes OUT', legend: 'Bytes OUT',
           width: 1
    end
    RRD.graph "#{@vpn}-cli.png",
              title: 'VPN clients',
              width: 800, height: 250,
              color: ['FONT#000000', 'BACK#FFFFFF'] do
      line rrd_file,
           clients: :average,
           color: '#0000FF',
           label: 'Clients', legend: 'Clients',
           width: 1
    end
    return ["#{@vpn}-trf.png", "#{@vpn}-cli.png"]
  end

  private

  def create
    @vpn_rrd.create start: Time.now - 1.minute, step: 5.minutes do
      datasource 'bytes_in',  type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
      datasource 'bytes_out', type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
      datasource 'clients',   type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
      archive :average, every: 10.minutes, during: 1.year
    end
  end
end
