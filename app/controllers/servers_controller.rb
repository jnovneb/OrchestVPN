class ServersController < ApplicationController
  before_action :set_server, only: %i[show edit update destroy]

  # GET /servers or /servers.json
  def index
    @servers = Server.all
  end

  # GET /servers/1 or /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers or /servers.json
  def create
    name = params[:server][:name]
    address = params[:server][:addr]
    accept_IPV6 = params[:server][:IPV6]
    port = params[:server][:port]
    protocol = params[:server][:protocol]
    dns = params[:server][:dns]
    primarydns = params[:server][:primaryDNS]
    secondarydns = params[:server][:secondaryDNS]
    compressbtn = params[:server][:compression]
    compression = params[:server][:compression_options]
    encryptbtn = params[:server][:encryption]
    encrypt = params[:server][:encryption_options]
    encrypt_cert = params[:server][:encrypt_cert]
    compress_encrypt = params[:server][:compression_options_enc]
    key_size_encrypt = params[:server][:compression_options_key]
    control_cipher = params[:server][:control_cipher]
    control_channel = params[:server][:control_channel_cipher]
    control_channel2 = params[:server][:control_channel_cipher2]
    diffie_hellman = params[:server][:diffie_hellman]
    control_cipherDH = params[:server][:control_cipherDH]
    control_cipherDH2 = params[:server][:control_cipherDH2]
    digest_algorithm = params[:server][:digest_algorithm]
    tls_sig = params[:server][:tls_sig]

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
case control_cipher
when "1"
  controlCiphertxt += "ECDHE-ECDSA-AES-128-GCM-SHA256\n"
when "2"
  controlCiphertxt += "ECDHE-ECDSA-AES-256-GCM-SHA384\n"
else
  controlCiphertxt = "\n"
end

controlCipherChanneltxt = "Cipher channel: "
case control_channel
when "1"
  controlCipherChanneltxt += "ECDHE-RSA-AES-128-GCM-SHA256\n"
when "2"
  controlCipherChanneltxt += "ECDHE-RSA-AES-256-GCM-SHA384\n"
else
  controlCipherChanneltxt = "\n"
end

controlCipherChannel2txt = "Cipher channel: "
case control_channel2
when "1"
  controlCipherChannel2txt += "TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256\n"
when "2"
  controlCipherChannel2txt += "TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256\n"
else
  controlCipherChannel2txt = "\n"
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

opciones = "#{name}\n#{address}\n#{port}\n#{protocol}\n#{dnstext}#{compresstxt}#{encrypttxt}#{curveencrypttxt}#{sizekeytxt}#{controlCiphertxt}#{controlCipherChanneltxt}#{controlCipherChannel2txt}#{dhtxt}#{dhopttxt}#{dhopttxt2}#{digesttxt}#{tlstxt}"
puts opciones

puts name
@server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to server_url(@server), notice: "Server was successfully created." }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1 or /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        format.html { redirect_to server_url(@server), notice: "Server was successfully updated." }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1 or /servers/1.json
  def destroy
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url, notice: "Server was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def server_params
      params.require(:server).permit(:name, :addr, :credentials, :hostkey, :CA)
    end


    def update_dns_visibility
      if params[:server][:use_password] == '1'
        @show_dns = true
      else
        @show_dns = false
      end

      respond_to do |format|
        format.js # Render the update_dns_visibility.js.erb file
      end
    end
end
