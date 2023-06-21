require 'net/telnet'

# Class to talk to the OpenVPN management interface
class OpenvpnManager
  # @param [Hash] options
  def initialize(options = {})
    @options = options
    @options['Host'] = 'localhost' unless @options.key?('Host')
    @options['Port'] = 7505        unless @options.key?('Port')
    begin
      # Create a new Telnet object
      @client = Net::Telnet.new(@options)
    rescue Net::Telnet::Error => e
      # Handle specific Net::Telnet errors
      puts "Net::Telnet error occurred: #{e.message}"
    rescue => e
      # Handle other general exceptions
      puts "An error occurred: #{e.message}"
    ensure
      # Make sure to close the Telnet connection
      @client.close if @client&.connected?
    end
  end

  def send_command(command)
    @client.puts(command)
    response = @client.waitfor('String' => /END/)
    response.split("\n")[1..-2].map(&:strip)
  end

  def status
    send_command('status')
  end

  def clients
    send_command('status 1')
  end

  def routes
    send_command('status 2')
  end

  def bytes
    send_command('load-stats')
  end

  def clients_bytes
    send_command('load-stats 1')
  end

  def version
    send_command('version')
  end
end
