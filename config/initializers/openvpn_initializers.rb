# Iniciar los servidores de OpenVPN después de que la aplicación de Rails se haya inicializado
Rails.application.config.after_initialize do
    password = "javier y pepo"
    system("echo '#{password}'|sudo -E -S #{Rails.root}/vendor/sh/init_servers_openvpn.sh")
end

