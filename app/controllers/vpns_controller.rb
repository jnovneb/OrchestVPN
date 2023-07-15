require 'rrd'

# Class to act as a interface between the VPN and the RRD files
class VPNtoRRD
  def initialize(vpn)
    @vpn      = vpn.to_s
    @vpn_file = Rails.root.join('vpn_files', 'rrd', "#{@vpn}.rrd").to_s
    @vpn_rrd  = RRD::Base.new(@vpn_file)
  end

  def update(bytes_in, bytes_out, clients)
    create unless File.exist? @vpn_file
    @vpn_rrd.update Time.now, bytes_in, bytes_out, clients
  end

  def graph
    # Local variable to avoid problems with the instance variable in module RRD
    rrd_file = @vpn_file
    graph0 = Rails.root.join('app', 'assets', 'images', 'rrd', "#{@vpn}-trf.png").to_s
    graph1 = Rails.root.join('app', 'assets', 'images', 'rrd', "#{@vpn}-cli.png").to_s
    RRD.graph graph0,
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
    RRD.graph graph1,
              title: 'VPN clients',
              width: 800, height: 250,
              color: ['FONT#000000', 'BACK#FFFFFF'] do
      line rrd_file,
           clients: :average,
           color: '#0000FF',
           label: 'Clients', legend: 'Clients',
           width: 1
    end
    return ["assets/images/rrd/#{@vpn}-trf.png", "assets/images/rrd/#{@vpn}-cli.png"]
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


class VpnsController < ApplicationController
  before_action :set_vpn, only: %i[ show edit update destroy ]

  @password = Rails.application.credentials.sudo_pass

  # GET /vpns or /vpns.json
  def index
    @vpns = if current_user.admin
              Vpn.all
            else
              current_user.users_vpns.where(admin_vpn: true).map(&:vpn)
            end
  end

  # GET /vpns/1 or /vpns/1.json
  def show
    @vpn = Vpn.find(params[:id])
    @vpn_rrd = VPNtoRRD.new @vpn.name
    @graphs = @vpn_rrd.graph
  end

  # GET /vpns/new
  def new
    @vpn = Vpn.new
  end

  # GET /vpns/1/edit
  def edit
  end

  # POST /vpns or /vpns.json
  def create
    # Verificar y asignar usuarios seleccionados
    user_ids = params[:vpn][:users].reject(&:empty?) if params[:vpn][:users]
    users = User.where(id: user_ids)
    params[:vpn][:users] = users if users.present?

    # Verificar y asignar administradores seleccionados
    admin_ids = params[:vpn][:vpn_admin_list].reject(&:empty?) if params[:vpn][:vpn_admin_list]
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?

    # WHAAAAAAAAAAAT THE FFFFFFFFFF
    # TODO: Refactor this... mess?
    admin_ids = params[:vpn][:vpn_admin_list].is_a?(Array) ? params[:vpn][:vpn_admin_list].reject(&:empty?) : []
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?

    number_of_vpns = Vpn.count
    cidr = calculate_cidr(number_of_vpns)

    name = params[:vpn][:name]
    address = params[:vpn][:addr]
    accept_IPV6 = params[:vpn][:IPv6]
    port = params[:vpn][:port]
    protocol = params[:vpn][:protocol]
    dns = params[:vpn][:dns]
    primarydns = params[:vpn][:primaryDNS]
    secondarydns = params[:vpn][:secondaryDNS]
    compressbtn = params[:vpn][:compression]
    compression = params[:vpn][:compression_options]
    encryptbtn = params[:vpn][:encryption]
    encrypt = params[:vpn][:encryption_options]
    encrypt_cert = params[:vpn][:encrypt_cert]
    compress_encrypt = params[:vpn][:compression_options_enc]
    key_size_encrypt = params[:vpn][:compression_options_key]
    control_cipher = params[:vpn][:control_cipher]
    diffie_hellman = params[:vpn][:diffie_hellman]
    control_cipherDH = params[:vpn][:control_cipherDH]
    control_cipherDH2 = params[:vpn][:control_cipherDH2]
    digest_algorithm = params[:vpn][:digest_algorithm]
    tls_sig = params[:vpn][:tls_sig]

    vpn_params[:CIDR] = cidr

    primarydns   = 'nil' if primarydns.nil?
    secondarydns = 'nil' if secondarydns.nil?
    encrypt_cert = 'nil' if encrypt_cert.nil?

=begin
    puts 'Params in variables:', admins, users, cidr, name, address, accept_IPV6,
         port, protocol, dns, primarydns, secondarydns, compressbtn,
         compression, encryptbtn, encrypt, encrypt_cert, compress_encrypt,
         key_size_encrypt, control_cipher, diffie_hellman, control_cipherDH,
         control_cipherDH2, digest_algorithm, tls_sig
=end

    dns_types = { '1': "Current system resolvers\n", '2': "Self-hosted DNS\n", '3': "Cloudflare\n",
                  '4': "Quad9\n", '5': "Quad9 uncensored\n", '6': "FDN (France)\n", '7': "OpenDNS\n",
                  '9': "Google\n", '10': "Yandex Basic (Russia)\n", '11': "AdGuard DNS\n",
                  '12': "NextDNS\n", '13': "Custom DNS. Primary DNS: #{primarydns}. Secondary DNS: #{secondarydns}\n" }
    dns_txt = "DNS option selected: #{dns_types[dns]}"

    if compressbtn == 'yes'
      compression_types = Hash.new("Error\n")
      compression_types.merge!({'1' => "lz4-v2\n", '2' => "lz4\n", '3' => "lzo\n"})
      compress_txt = "Compression selected: #{compression_types[compression]}"
    end

    encrypt_txt = "Default encryption: CIPHER=AES-128-GCM, CERT_TYPE=ECDSA, CERT_CURVE=prime256v1, CC_CIPHER=TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256, DH_TYPE=ECDH, DH_CURVE=prime256v1, HMAC_ALG=SHA256, TLS_SIG=tls-crypt\n"
    curve_encrypt_txt = ''
    key_size_txt = ''
    if encryptbtn == 'yes'
      encryption_types = { '1' => "AES-128-GCM\n", '2' => "AES-192-GCM\n", '3' => "AES-256-GCM\n",
                           '4' => "AES-128-CBC\n", '5' => "AES-192-CBC\n", '6' => "AES-256-CBC\n" }
      encrypt_txt = "Encryption selected: #{encryption_types[encrypt]}"
      encrypt_cert_types = { '1' => "ECDSA\n", '2' => "RSA\n" }
      encrypt_txt += "Using: #{encrypt_cert_types[encrypt_cert]}"

      curve_encrypt_types = Hash.new("\n")
      curve_encrypt_types.merge!( {'1' => "prime256v1\n", '2' => "secp384r1\n", '3' => "secp521r1\n"} )
      curve_encrypt_txt = 'Curve selected: ' + curve_encrypt_types[compress_encrypt]

      key_size_types = Hash.new("\n")
      key_size_types.merge!( {'1' => "2048 bits\n", '2' => "3072 bits\n", '3' => "4096 bits\n"} )
      key_size_txt = 'Size selected: ' + key_size_types[key_size_encrypt]
    end

    control_cipher_types_ECDSA = Hash.new("\n")
    control_cipher_types_ECDSA.merge!({'1' => "ECDHE-ECDSA-AES-128-GCM-SHA256\n", '2' => "ECDHE-ECDSA-AES-256-GCM-SHA384\n"})
    control_cipher_types_RSA   = Hash.new("\n")
    control_cipher_types_RSA.merge!( {'1' => "ECDHE-RSA-AES-128-GCM-SHA256\n", '2' => "ECDHE-RSA-AES-256-GCM-SHA384\n"} )
    control_cipher_txt = if 'Cipher for the control channel: ' + encrypt_cert == '1'
                           control_cipher_types_ECDSA[control_cipher]
                         else
                           control_cipher_types_RSA[control_cipher]
                         end
    dh_types = Hash.new("\n")
    dh_types.merge!( {'1' => "ECDH\n", '2' => "DH\n"} )
    dh_txt = 'Diffie-Hellman key: ' + dh_types[diffie_hellman]

    dhopt_types = Hash.new("\n")
    dhopt_types.merge!( {'1' => "prime256v1\n", '2' => "secp384r1\n", '3' => "secp521r1\n"} )
    dhopt_txt = 'Curve type: ' + dhopt_types[control_cipherDH]

    dh2_types = Hash.new("\n")
    dh2_types.merge!( {'1' => "2048 bits\n", '2' => "3072 bits\n", '3' => "4096 bits\n"} )
    dh2_txt = 'Size of the Diffie-Hellman key: ' + dh2_types[control_cipherDH2]

    digest_types = Hash.new("\n")
    digest_types.merge!( {'1' => "SHA-256\n", '2' => "SHA-384\n", '3' => "SHA-512\n"} )
    digest_txt = 'Digest algorithm for HMAC: ' + digest_types[digest_algorithm]

    tls_types = Hash.new("\n")
    tls_types.merge!( {'1' => "tls-crypt\n", '2' => "tls-auth\n"} )
    tls_txt = 'Additional security: ' + tls_types[tls_sig]

    opciones =  "#{name}\n#{address}\n#{port}\n#{protocol}\n#{dns_txt}\n#{compress_txt}\n"
    opciones += "#{encrypt_txt}\n#{curve_encrypt_txt}\n#{key_size_txt}\n#{control_cipher_txt}\n"
    opciones += "#{dh_txt}\n#{dhopt_txt}\n#{dh2_txt}\n#{digest_txt}\n#{tls_txt}\n"

    #    puts 'Opciones', opciones

    ruta = Rails.root.join('vpn_files')
=begin
    puts ruta, name, address, accept_IPV6, port, protocol, dns, primarydns, secondarydns,
         compressbtn, compression, encryptbtn, encrypt, encrypt_cert, compress_encrypt,
         key_size_encrypt, control_cipher, diffie_hellman, control_cipherDH,
         control_cipherDH2, digest_algorithm, tls_sig
=end
    @vpn = Vpn.new(vpn_params)
    # TODO: Make safeguard for when the server is not found and try to remove the hardwired one
    @vpn.server = Server.find_by(id: '1')
    serv = @vpn.server.name
    server_id = @vpn.server.id
    #    puts server_id
    @vpn.server_id = server_id

    portint = port.to_i
    management = (portint + 7500).to_s
    @vpn.managementPort = management
    # Llamar al script de Bash con los argumentos recopilados
    command = "echo '#{@password}' | sudo -E -S #{Rails.root.to_s}/vendor/sh/VPNInstalation.sh #{ruta} #{name} #{address} #{accept_IPV6} #{port} #{protocol} #{dns} #{primarydns} #{secondarydns} #{compressbtn} #{compression} #{encryptbtn} #{encrypt} #{encrypt_cert} #{compress_encrypt} #{key_size_encrypt} #{control_cipher} #{diffie_hellman} #{control_cipherDH} #{control_cipherDH2} #{digest_algorithm} #{tls_sig} #{serv} #{cidr}"
    system(command)

    vpn_files_path = Rails.root.join('vpn_files', "#{serv}", "#{name}").to_s
    crt = vpn_files_path + "/#{name}.crt"
    key = vpn_files_path + "/#{name}.key"

    archivo = File.read(crt)
    cert = archivo.scan(/-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----/m).flatten.first

    archivo2 = File.read(key)
    hostkey = archivo2.scan(/-----BEGIN PRIVATE KEY-----(.*?)-----END PRIVATE KEY-----/m).flatten.first

    @vpn.update(options:     opciones)
    @vpn.update(certificate: cert)
    @vpn.update(hostkey:     hostkey)

    respond_to do |format|
      if @vpn.save
        # Actualizar el parámetro admin_vpn para el usuario actual
        current_user_vpn = @vpn.users_vpns.find_by(user_id: current_user.id)
        current_user_vpn.update(admin_vpn: true)

        format.html { redirect_to vpns_url(@vpn), notice: 'VPN was successfully created.' }
        format.json { render :show, status: :created, location: @vpn }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vpn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vpns/1 or /vpns/1.json
  def update
    respond_to do |format|
      if @vpn.update(vpn_params)
        format.html { redirect_to vpn_url(@vpn), notice: 'Vpn was successfully updated.' }
        format.json { render :show, status: :ok, location: @vpn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vpn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vpns/1 or /vpns/1.json
  def destroy
    name = @vpn.name
    servername = @vpn.server.name

    # TODO: Check these paths
    ruta  = Rails.root.join('vpn_files', "#{servername}","#{name}", 'Clients').to_s
    ruta2 = Rails.root.join('vpn_files', "#{servername}","#{name}").to_s

    # Obtener la lista de archivos .ovpn en el directorio
    @vpns = Dir.glob(File.join(ruta, '*.ovpn'))

    @vpns.each do |archivo|
      # Obtener el nombre del archivo sin la extensión .ovpn
      nombre = File.basename(archivo, '.ovpn')
      # Llamar al script de Bash con los argumentos recopilados
      command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
      system(command)
    end

    command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleServer.sh #{name} #{ruta2}"
    system(command)

    # Delete records related to the users_vpn table
    @vpn.users_vpns.destroy_all
    @vpn.destroy

    FileUtils.rm_rf(ruta)

    respond_to do |format|
      format.html { redirect_to vpns_url, notice: 'Vpn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions
  def set_vpn
    @vpn = Vpn.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def vpn_params
    params.require(:vpn).permit(:name, :description, :port, :bandwidth, user_ids: [], vpn_admin_list: [])
  end

  # Calculate the CIDR automatically avoiding human failures
  def calculate_cidr(number_of_vpns)
    if number_of_vpns / 254 == 0
      "10.8.#{number_of_vpns}.0"
    else
      x = 8 + number_of_vpns % 254
      "10.#{x}.#{number_of_vpns % 254}.0"
    end
  end
end
