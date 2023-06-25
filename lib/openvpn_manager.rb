require 'net/telnet'

# Class to talk to the OpenVPN management interface.
# This class is kind of a wrapper around the Net::Telnet class.
# Inspired by https://github.com/dguerri/openvpn_management
class OpenvpnManager
  # @param [Hash] options
  def initialize(options = {})
    @options = options
    @options[Host:]    = 'localhost' unless @options.key?(Host:)
    @options[Port:]    = 7505        unless @options.key?(Port:)
    @options[Timeout:] = 10          unless @options.key?(Timeout:)
    @options[Prompt:]  = />INFO:OpenVPN.*\n/
    begin
      # Create a new Telnet object
      @client = Net::Telnet::new(@options)
      @client.login('LoginPrompt' => /ENTER PASSWORD:/, 'Name' => @options['Password']) if @options['Password']
    rescue => e
      puts "Unable to create a new Telnet object: #{e.message}"
    end
  end

  # Destroy an OpenVPN management telnet session
  def destroy
    @client.close if @client&.connected?
  end

  # Get information about clients connected list and routing table. Return two arrays of arrays with lists inside.
  # For each client in client_list array there is: Common Name, Addressing Infos, Bytes in/out, Uptime.
  # Instead for each route entry there is: IP/Eth Address (depend on tun/tap mode), Addressing, Uptime.
  # @return [Hash{Symbol->Unknown}]
  def status
    client_list_flag = 0, routing_list_flag = 0
    clients = {}
    routes = {}

    unless @client.nil?
      c = send_command 'status'
      c.split("\n").each do |line|
        # End Information Markers
        client_list_flag  = 0 if line == 'ROUTING TABLE'
        routing_list_flag = 0 if line == 'GLOBAL STATS'
        # Update Clients Connected List
        # Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since
        if client_list_flag == 1
          client = line.split(',')
          clients[client[0]] ||= []
          clients[client[0]] << {
            real_address: client[1],
            bytes_received: client[2],
            bytes_sent: client[3],
            connected_since: client[4].chop
          }
        end
        # Update Routing Info List
        # Virtual Address,Common Name,Real Address,Last Ref
        if routing_list_flag == 1
          route = line.split(',')
          routes[route[0]] = { common_name: route[1], real_address: route[2], last_ref: route[3] }
        end
        # Start Information Markers
        client_list_flag  = 1 if line == 'Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since'
        routing_list_flag = 1 if line == 'Virtual Address,Common Name,Real Address,Last Ref'
      end
    end
    { clients:, routes: }
  end

  # Get information about number of clients connected and traffic statistic (bytes in & bytes out)
  def stats
    stats_arr = send_command('load-stats').split(',')
    {
      clients: stats_arr[0].gsub('nclients=', '').to_i,
      bytes_download: stats_arr[1].gsub('bytesin=', '').to_i,
      bytes_upload: stats_arr[2].chop!.gsub('bytesout=', '').to_i
    }
  end

  # Returns a string showing the processes and management interface's version
  def version
    send_command 'version'
  end

  # Returns process ID of the current OpenVPN process
  def pid
    send_command 'pid'
  end

  # Send signal s to daemon, where s can be SIGHUP, SIGTERM, SIGUSR1, SIGUSR2
  def signal(s)
    unless %w[SIGHUP SIGTERM SIGUSR1 SIGUSR2].include? s
      raise ArgumentError "Unsupported signal '#{s}' (Only SIGHUP, SIGTERM, SIGUSR1, SIGUSR2)"
    end
    send_command "signal #{s}"
  end

  # Set log verbosity level to n, or show if n is absent
  # @param [Integer] n
  def verb(n=-1)
    send_command(n >= 0 ? "verb #{n}" : 'verb')
  end

  # Set log mute level to n, or show level if n is absent
  # @param [Integer] n
  def mute(n=-1)
    send_command(n >= 0 ? "mute #{n}" : 'mute')
  end

  # Kill the client instance(s) by common name of host:port combination
  def kill(options)
    cn   = options[:common_name]
    host = options[:host]
    port = options[:port]

    if cn
      send_command "kill #{cn}"
    elsif host && port
      send_command "kill #{host}:#{port}"
    else
      raise ':common_name or :host + :port combination needed'
    end
  end

  private

  # Send a command to the OpenVPN management interface
  def send_command(command)
    return if @client.nil?

    c = @client.cmd('String' => command, 'Match' => /(SUCCESS:.*\n|ERROR:.*\n|END.*\n)/)
    if c =~ /\AERROR\: (.+)\n\Z/
      raise Regexp.last_match 1
    elsif c =~ /\ASUCCESS\: (.+)\n\Z/
      Regexp.last_match 1
    else
      c
    end
  end
end
