class VpnsController < ApplicationController
  before_action :set_vpn, only: %i[ show edit update destroy ]

  @password = 'javier y pepo'

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

    # TODO: Is it necessary here? Is it reachable? Check it
    cidr = params[:vpn][:CIDR]

    # Verificar y asignar administradores seleccionados
    admin_ids = params[:vpn][:vpn_admin_list].reject(&:empty?) if params[:vpn][:vpn_admin_list]
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?

    # WHAAAAAAAAAAAT THE FFFFFFFFFF
    # TODO: Refactorizar esto
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

    puts admins, users, cidr, name, address, accept_IPV6, port, protocol, dns,
         primarydns, secondarydns, compressbtn, compression, encryptbtn,
         encrypt, encrypt_cert, compress_encrypt, key_size_encrypt,
         control_cipher, diffie_hellman, control_cipherDH, control_cipherDH2,
         digest_algorithm, tls_sig

    dnstext = 'DNS option selected: '
    dnstext += case dns
               when '1'
                 "Current system resolvers\n"
               when '2'
                 "Self-hosted DNS\n"
               when '3'
                 "Cloudflare\n"
               when '4'
                 "Quad9\n"
               when '5'
                 "Quad9 uncensored\n"
               when '6'
                 "FDN (France)\n"
               when '7'
                 "OpenDNS\n"
               when '9'
                 "Google\n"
               when '10'
                 "Yandex Basic (Russia)\n"
               when '11'
                 "AdGuard DNS\n"
               when '12'
                 "NextDNS\n"
               when '13'
                 "Custom DNS. Primary DNS: #{primarydns}. Secondary DNS: #{secondarydns}\n"
               end

    if compressbtn == 'yes'
      compresstxt = 'Compression selected: '
      compresstxt += case compression
                     when '1'
                       "lz4-v2\n"
                     when '2'
                       "lz4\n"
                     when '3'
                       "lzo\n"
                     else
                       "Error\n"
                     end
    end
    if encryptbtn == 'yes'
      encrypttxt = 'Encryption selected: '
      encrypttxt += case encrypt
                    when '1'
                      'AES-128-GCM. '
                    when '2'
                      'AES-192-GCM. '
                    when '3'
                      'AES-256-GCM. '
                    when '4'
                      'AES-128-CBC. '
                    when '5'
                      'AES-192-CBC. '
                    when '6'
                      'AES-256-CBC. '
                    end
      encrypttxt += 'Using: '
      encrypttxt += case encrypt_cert
                    when '1'
                      "ECDSA\n"
                    when '2'
                      "RSA\n"
                    end
      curveencrypttxt = 'Curve selected: '
      curveencrypttxt += case compress_encrypt
                         when '1'
                           "prime256v1\n"
                         when '2'
                           "secp384r1\n"
                         when '3'
                           "secp521r1\n"
                         else
                           "\n"
                         end
      sizekeytxt = 'Size selected: '
      sizekeytxt += case key_size_encrypt
                    when '1'
                      "2048 bits\n"
                    when '2'
                      "3072 bits\n"
                    when '3'
                      "4096 bits\n"
                    else
                      "\n"
                    end
    else
      encrypttxt = "Default encryption: CIPHER=AES-128-GCM, CERT_TYPE=ECDSA, CERT_CURVE=prime256v1, CC_CIPHER=TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256, DH_TYPE=ECDH, DH_CURVE=prime256v1, HMAC_ALG=SHA256, TLS_SIG=tls-crypt\n"
      curveencrypttxt = ''
      sizekeytxt = ''
    end

    controlCiphertxt = 'Cipher for the control channel: '
    controlCiphertxt += if encrypt_cert == '1'   # ECDSA
                          case control_cipher
                            when '1'
                              "ECDHE-ECDSA-AES-128-GCM-SHA256\n"
                            when '2'
                              "ECDHE-ECDSA-AES-256-GCM-SHA384\n"
                            else
                              "\n"
                          end
                        else                     # RSA
                          case control_cipher
                            when '1'
                              "ECDHE-RSA-AES-128-GCM-SHA256\n"
                            when '2'
                              "ECDHE-RSA-AES-256-GCM-SHA384\n"
                            else
                              "\n"
                          end
                        end

    dhtxt = 'Diffie-Hellman key: '
    dhtxt += case diffie_hellman
             when '1'
               "ECDH\n"
             when '2'
               "DH\n"
             else
               "\n"
             end
    dhopttxt = 'Curve type: '
    dhopttxt += case control_cipherDH
                when '1'
                  "prime256v1\n"
                when '2'
                  "secp384r1\n"
                when '3'
                  "secp521r1\n"
                else
                  "\n"
                end
    dhopttxt2 = 'Size of the Diffie-Hellman key: '
    dhopttxt2 += case control_cipherDH2
                 when '1'
                   "2048 bits\n"
                 when '2'
                   "3072 bits\n"
                 when '3'
                   "4096 bits\n"
                 else
                   "\n"
                 end
    digesttxt = 'Digest algorithm for HMAC: '
    digesttxt += case digest_algorithm
                 when '1'
                   "SHA-256\n"
                 when '2'
                   "SHA-384\n"
                 when '3'
                   "SHA-512\n"
                 else
                   "\n"
                 end
    tlstxt = 'Additional security: '
    tlstxt += case tls_sig
              when '1'
                "tls-crypt\n"
              when '2'
                "tls-auth\n"
              else
                "\n"
              end

    opciones = "#{name}\n#{address}\n#{port}\n#{protocol}\n#{dnstext}#{compresstxt}#{encrypttxt}#{curveencrypttxt}#{sizekeytxt}#{controlCiphertxt}#{dhtxt}#{dhopttxt}#{dhopttxt2}#{digesttxt}#{tlstxt}"
    puts opciones

    ruta = Rails.root.join('vpn_files')

    puts ruta, name, address, accept_IPV6, port, protocol, dns, primarydns, secondarydns,
         compressbtn, compression, encryptbtn, encrypt, encrypt_cert, compress_encrypt,
         key_size_encrypt, control_cipher, diffie_hellman, control_cipherDH,
         control_cipherDH2, digest_algorithm, tls_sig

    @vpn = Vpn.new(vpn_params)
    @vpn.server = Server.find_by(id: '1')
    serv = @vpn.server.name
    server_id = @vpn.server.id
    puts server_id
    @vpn.server_id = server_id
    # Llamar al script de Bash con los argumentos recopilados
    command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/VPNInstalation.sh #{ruta} #{name} #{address} #{accept_IPV6} #{port} #{protocol} #{dns} #{primarydns} #{secondarydns} #{compressbtn} #{compression} #{encryptbtn} #{encrypt} #{encrypt_cert} #{compress_encrypt} #{key_size_encrypt} #{control_cipher} #{diffie_hellman} #{control_cipherDH} #{control_cipherDH2} #{digest_algorithm} #{tls_sig} #{serv} #{cidr}"
    system(command)

    vpn_files_path = Rails.root.join('vpn_files', "#{serv}", "#{name}")
    crt = vpn_files_path + "#{name}.crt"
    key = vpn_files_path + "#{name}.key"

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
        current_user_vpn.update(admin_vpn: true) if current_user_vpn

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

    #REVISA RUTA
    ruta = Rails.root.join('vpn_files', "#{servername}","#{name}", 'Clients')
    ruta2 = Rails.root.join('vpn_files', "#{servername}","#{name}")

    @vpns = Dir.glob(File.join(ruta, '*.ovpn')) # Obtener la lista de archivos .ovpn en el directorio

    @vpns.each do |archivo|
      nombre = File.basename(archivo, '.ovpn') # Obtener el nombre del archivo sin la extensión .ovpn

      # Llamar al script de Bash con los argumentos recopilados
      command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
      system(command)
    end

    command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleServer.sh #{name} #{ruta2}"
    system(command)

    #Delete registers related in the users_vpn table
    @vpn.users_vpns.destroy_all
    @vpn.destroy

    FileUtils.rm_rf(ruta)

    respond_to do |format|
      format.html { redirect_to vpns_url, notice: 'Vpn was successfully destroyed.' }
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
    params.require(:vpn).permit(:name, :description, :port, :bandwidth, user_ids: [], vpn_admin_list: [])
  end

  #Calculate the CIDR automatically avoiding human failures
  def calculate_cidr(number_of_vpns)
    if number_of_vpns / 254 == 0
      "10.8.#{number_of_vpns}.0"
    else
      x = 8 + number_of_vpns % 254
      "10.#{x}.#{number_of_vpns % 254}.0"
    end
  end
end
