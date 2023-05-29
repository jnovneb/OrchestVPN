require 'rails_helper'

RSpec.describe "clients/show", type: :view do
  before(:each) do
    assign(:client, Client.create!(
      vpn: "Vpn",
      name: "Name",
      desc: "Desc",
      cert: "Cert",
      options: "Options"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Vpn/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Desc/)
    expect(rendered).to match(/Cert/)
    expect(rendered).to match(/Options/)
  end
end
