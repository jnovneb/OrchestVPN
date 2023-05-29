json.extract! server, :id, :name, :addr, :credentials, :hostkey, :CA, :created_at, :updated_at
json.url server_url(server, format: :json)
