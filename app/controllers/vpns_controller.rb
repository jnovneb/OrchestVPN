class VpnsController < ApplicationController
  before_action :set_vpn, only: %i[ show edit update destroy ]
  

  # GET /vpns or /vpns.json
  def index
    if current_user.admin
      @vpns = Vpn.all
    else
      @vpns = current_user.users_vpns.where(admin_vpn: true).map(&:vpn)
    end
  end
  

  # GET /vpns/1 or /vpns/1.json
  def show
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

    cidr = params[:vpn][:CIDR]
    
    # Verificar y asignar administradores seleccionados
    admin_ids = params[:vpn][:vpn_admin_list].reject(&:empty?) if params[:vpn][:vpn_admin_list]
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?

    password = "javier y pepo"


    admin_ids = params[:vpn][:vpn_admin_list].is_a?(Array) ? params[:vpn][:vpn_admin_list].reject(&:empty?) : []
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?
    cidr = params[:vpn][:CIDR]


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

    if primarydns.nil?
      primarydns = "nil"
    end

    if secondarydns.nil?
      secondarydns = "nil"
    end
    if encrypt_cert.nil?
      encrypt_cert = "nil"
    end
    puts dns
    puts primarydns
    puts secondarydns
    puts compressbtn
    puts compression
    puts encryptbtn
    puts encrypt
    puts encrypt_cert
    puts compress_encrypt
    puts key_size_encrypt
    puts control_cipher
    puts diffie_hellman
    puts control_cipherDH
    puts control_cipherDH2
    puts digest_algorithm
    puts tls_sig

    dnstext = "DNS option selected: "

    case dns
    when "1"
      dnstext += "Current system resolvers\n"
    when "2"
      dnstext += "Self-hosted DNS\n"
    when "3"
      dnstext += "Cloudflare\n"
    when "4"
      dnstext += "Quad9\n"
    when "5"
      dnstext += "Quad9 uncensored\n"
    when "6"
      dnstext += "FDN (France)\n"
    when "7"
      dnstext += "OpenDNS\n"
    when "9"
      dnstext += "Google\n"
    when "10"
      dnstext += "Yandex Basic (Russia)\n"
    when "11"
      dnstext += "AdGuard DNS\n"
    when "12"
      dnstext += "NextDNS\n"
    when "13"
      dnstext += "Custom DNS. Primary DNS: #{primarydns}. Secondary DNS: #{secondarydns}\n"
    end

    opciones=""
   

  if compressbtn == "yes"
    compresstxt = "Compression selected: "
    case compression
    when "1"
      compresstxt += "lz4-v2\n"
    when "2"
      compresstxt += "lz4\n"
    when "3"
      compresstxt += "lzo\n"
    else
      compresstxt += "Error\n"
    end
  end

  if encryptbtn == "yes"
    encrypttxt = "Encryption selected: "
    case encrypt
    when "1"
      encrypttxt += "AES-128-GCM. "
    when "2"
      encrypttxt += "AES-192-GCM. "
    when "3"
      encrypttxt += "AES-256-GCM. "
    when "4"
      encrypttxt += "AES-128-CBC. "
    when "5"
      encrypttxt += "AES-192-CBC. "
    when "6"
      encrypttxt += "AES-256-CBC. "
    end

    encrypttxt += "Using: "
    case encrypt_cert
    when "1"
      encrypttxt += "ECDSA\n"
    when "2"
      encrypttxt += "RSA\n"
    end

    curveencrypttxt = "Curve selected: "
    case compress_encrypt
    when "1"
      curveencrypttxt += "prime256v1\n"
    when "2"
      curveencrypttxt += "secp384r1\n"
    when "3"
      curveencrypttxt += "secp521r1\n"
    else
      curveencrypttxt = "\n"
    end

    sizekeytxt = "Size selected: "
    case key_size_encrypt
    when "1"
      sizekeytxt += "2048 bits\n"
    when "2"
      sizekeytxt += "3072 bits\n"
    when "3"
      sizekeytxt += "4096 bits\n"
    else
      sizekeytxt = "\n"
    end
  else
    encrypttxt = "Default encryption: CIPHER=AES-128-GCM, CERT_TYPE=ECDSA, CERT_CURVE=prime256v1, CC_CIPHER=TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256, DH_TYPE=ECDH, DH_CURVE=prime256v1, HMAC_ALG=SHA256, TLS_SIG=tls-crypt\n"
    curveencrypttxt = ""
    sizekeytxt = ""
  end

  controlCiphertxt = "Cipher for the control channel: "
  if encrypt_cert =="1"
    case control_cipher
    when "1"
      controlCiphertxt += "ECDHE-ECDSA-AES-128-GCM-SHA256\n"
    when "2"
      controlCiphertxt += "ECDHE-ECDSA-AES-256-GCM-SHA384\n"
    else
      controlCiphertxt = "\n"
    end
  else 
    case control_cipher
    when "1"
      controlCiphertxt += "ECDHE-RSA-AES-128-GCM-SHA256\n"
    when "2"
      controlCiphertxt += "ECDHE-RSA-AES-256-GCM-SHA384\n"
    else
      controlCiphertxt = "\n"
    end
  end


  dhtxt = "Diffie-Hellman key: "
  case diffie_hellman
  when "1"
    dhtxt += "ECDH\n"
  when "2"
    dhtxt += "DH\n"
  else
    dhtxt = "\n"
  end

  dhopttxt = "Curve type: "
  case control_cipherDH
  when "1"
    dhopttxt += "prime256v1\n"
  when "2"
    dhopttxt += "secp384r1\n"
  when "3"
    dhopttxt += "secp521r1\n"
  else
    dhopttxt = "\n"
  end

  dhopttxt2 = "Size of the Diffie-Hellman key: "
  case control_cipherDH2
  when "1"
    dhopttxt2 += "2048 bits\n"
  when "2"
    dhopttxt2 += "3072 bits\n"
  when "3"
    dhopttxt2 += "4096 bits\n"
  else
    dhopttxt2 = "\n"
  end

  digesttxt = "Digest algorithm for HMAC: "
  case digest_algorithm
  when "1"
    digesttxt += "SHA-256\n"
  when "2"
    digesttxt += "SHA-384\n"
  when "3"
    digesttxt += "SHA-512\n"
  else
    digesttxt = "\n"
  end

  tlstxt = "Additional security: "
  case tls_sig
  when "1"
    tlstxt += "tls-crypt\n"
  when "2"
    tlstxt += "tls-auth\n"
  else
    tlstxt = "\n"
  end

  opciones = "#{name}\n#{address}\n#{port}\n#{protocol}\n#{dnstext}#{compresstxt}#{encrypttxt}#{curveencrypttxt}#{sizekeytxt}#{controlCiphertxt}#{dhtxt}#{dhopttxt}#{dhopttxt2}#{digesttxt}#{tlstxt}"

  puts opciones
  password = "javier y pepo"
  ruta = Rails.root.join('vpn_files').to_s


  puts ruta
  puts name
  puts address
  puts accept_IPV6
  puts port
  puts protocol
  puts dns
  puts primarydns
  puts secondarydns
  puts compressbtn
  puts compression
  puts encryptbtn
  puts encrypt
  puts encrypt_cert
  puts compress_encrypt
  puts key_size_encrypt
  puts control_cipher
  puts diffie_hellman
  puts control_cipherDH
  puts control_cipherDH2
  puts digest_algorithm
  puts tls_sig
  # Llamar al script de Bash con los argumentos recopilados
  command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/VPNInstalation.sh #{ruta} #{name} #{address} #{accept_IPV6} #{port} #{protocol} #{dns} #{primarydns} #{secondarydns} #{compressbtn} #{compression} #{encryptbtn} #{encrypt} #{encrypt_cert} #{compress_encrypt} #{key_size_encrypt} #{control_cipher} #{diffie_hellman} #{control_cipherDH} #{control_cipherDH2} #{digest_algorithm} #{tls_sig}"

  system(command)
  crt = Rails.root.join('vpn_files', "#{name}", "#{name}.crt").to_s
  key = Rails.root.join('vpn_files', "#{name}", "#{name}.key").to_s

  archivo = File.read(crt)
  cert = archivo.scan(/-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----/m).flatten.first

  archivo2 = File.read(key)
  hostkey = archivo2.scan(/-----BEGIN PRIVATE KEY-----(.*?)-----END PRIVATE KEY-----/m).flatten.first

  @vpn = Vpn.new(vpn_params)
  @vpn.server = Server.find(params[:vpn][:server_id])
  @vpn.update(options: opciones)
  @vpn.update(credentials: cert)
  @vpn.update(hostkey: hostkey)

  respond_to do |format|
    if @vpn.save

       # Actualizar el parámetro admin_vpn para el usuario actual
       current_user_vpn = @vpn.users_vpns.find_by(user_id: current_user.id)
       current_user_vpn.update(admin_vpn: true) if current_user_vpn

      format.html { redirect_to server_url(@server), notice: "VPN was successfully created." }
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
        format.html { redirect_to vpn_url(@vpn), notice: "Vpn was successfully updated." }
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
    password = "javier y pepo"
    #REVISA RUTA
    ruta = Rails.root.join('vpn_files', "#{servername}", "Clients", "#{name}").to_s
    
    @vpns = Dir.glob(File.join(ruta, '*.ovpn')) # Obtener la lista de archivos .ovpn en el directorio
    
    @vpns.each do |archivo|
      nombre = File.basename(archivo, '.ovpn') # Obtener el nombre del archivo sin la extensión .ovpn
    
      # Llamar al script de Bash con los argumentos recopilados
      command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
      system(command)
    end
    #Delete registers related in the users_vpn table
    @vpn.users_vpns.destroy_all
    @vpn.destroy

    FileUtils.rm_rf(ruta)
    
    respond_to do |format|
      format.html { redirect_to vpns_url, notice: "Vpn was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vpn
      @vpn = Vpn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vpn_params
      params.require(:vpn).permit(:name, :description, :port, :server_id, :bandwidth, user_ids: [], vpn_admin_list: [])
    end

end
