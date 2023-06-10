FactoryBot.define do
  factory :client do
    vpn { 'vpn' }
    name { 'vpn name' }
    desc { 'vpn description' }
    cert { 'vpn certificate' }
    options { 'vpn options string' }
  end
end
