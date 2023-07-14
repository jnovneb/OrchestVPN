Rails.application.config.after_initialize do
  # Enqueue VPN stats gathering
  GatherVpnStatsJob.perform_later
end
