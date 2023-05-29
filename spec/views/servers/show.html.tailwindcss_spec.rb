require 'rails_helper'

RSpec.describe "servers/show", type: :view do
  before(:each) do
    assign(:server, Server.create!(
      name: "Name",
      addr: "Addr",
      credentials: "Credentials",
      hostkey: "Hostkey",
      CA: "Ca"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Addr/)
    expect(rendered).to match(/Credentials/)
    expect(rendered).to match(/Hostkey/)
    expect(rendered).to match(/Ca/)
  end
end
