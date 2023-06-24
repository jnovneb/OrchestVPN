require 'rrd'


# fichero = Rails.root.join('vpn_files','rrd')+'fichero.rrd'
fichero = 'fichero.rrd'
rrdfile = RRD::Base.new(fichero)

rrdfile.create start: Time.now - 10.seconds, step: 5.minutes do
  datasource 'bytes_in', type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
  datasource 'bytes_out', type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
  datasource 'clients', type: :gauge, heartbeat: 10.minutes, min: 0, max: :unlimited
  archive :average, every: 10.minutes, during: 1.year
end

RRD.graph 'graph.png', title: 'VPN', width: 800, height: 250, color: ["FONT#000000", "BACK#FFFFFF"] do
  line fichero, bytes_in:  :average, color: "#0000FF", label: 'Bytes IN'
  line fichero, bytes_out: :average, color: "#00FF00", label: 'Bytes OUT'
  line fichero, clients:   :average, color: "#FF0000", label: 'Clients'
end

=begin

# Generating a graph or raising an exception if something bad happens
RRD.graph! "graph2.png", title: "Test", width: 800, height: 250, color: ["FONT#000000", "BACK#FFFFFF"] do
  area fichero, cpu0: :average, color: "#00FF00", label: "CPU 0"
  line fichero, cpu0: :average, color: "#007f3f"
  line fichero, memory: :average, color: "#0000FF", label: "Memory"
end


# Generating a more complex graph using advanced DSL
RRD.graph IMG_FILE, title: "Test", width: 800, height: 250, start: Time.now - 1.day, end: Time.now do
  for_rrd_data "cpu0", cpu0: :average, from: RRD_FILE
  for_rrd_data "mem", memory: :average, from: RRD_FILE
  using_calculated_data "half_mem", calc: "mem,2,/"
  using_value "mem_avg", calc: "mem,AVERAGE"
  draw_line data: "mem", color: "#0000FF", label: "Memory", width: 1
  draw_area data: "cpu0", color: "#00FF00", label: "CPU 0"
  print_comment "Information - "
  print_value "mem_avg", format: "%6.2lf %SB"
end

# Generating a graph using shift
RRD.graph IMG_FILE, title: "Test", width: 800, height: 250, start: Time.now - 1.day, end: Time.now do
  for_rrd_data "mem", memory: :average, from: RRD_FILE
  for_rrd_data "mem_yesterday", memory: :average, from: RRD_FILE, start: Time.now - 2.day
  draw_line data: "mem", color: "#0000FF", label: "Memory", width: 1
  shift mem_yesterday: 1.day
  draw_line data: "mem_yesterday", color: "#0000FF", label: "Yesterday memory", width: 1
end

=end
