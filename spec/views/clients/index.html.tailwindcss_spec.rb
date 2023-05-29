require 'rails_helper'

RSpec.describe "clients/index", type: :view do
  before(:each) do
    assign(:clients, [
      Client.create!(
        vpn: "Vpn",
        name: "Name",
        desc: "Desc",
        cert: "Cert",
        options: "Options"
      ),
      Client.create!(
        vpn: "Vpn",
        name: "Name",
        desc: "Desc",
        cert: "Cert",
        options: "Options"
      )
    ])
  end

  it "renders a list of clients" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Vpn".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Desc".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cert".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Options".to_s), count: 2
  end
end
