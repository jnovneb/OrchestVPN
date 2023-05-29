json.extract! client, :id, :vpn, :name, :desc, :cert, :options, :created_at, :updated_at
json.url client_url(client, format: :json)
