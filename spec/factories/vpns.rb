FactoryBot.define do
  factory :vpn do
    name { "MyString" }
    description { "MyText" }
    protocol { "MyString" }
    port { 1 }
    server { "MyString" }
    options { "MyText" }
    technology { "MyString" }
    VPNAdminList { "MyString" }
    version { "MyString" }
  end
end
