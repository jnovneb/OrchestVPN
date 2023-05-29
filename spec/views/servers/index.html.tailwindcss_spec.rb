require 'rails_helper'

RSpec.describe "servers/index", type: :view do
  before(:each) do
    assign(:servers, [
      Server.create!(
        name: "Name",
        addr: "Addr",
        credentials: "Credentials",
        hostkey: "Hostkey",
        CA: "Ca"
      ),
      Server.create!(
        name: "Name",
        addr: "Addr",
        credentials: "Credentials",
        hostkey: "Hostkey",
        CA: "Ca"
      )
    ])
  end

  it "renders a list of servers" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Addr".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Credentials".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Hostkey".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Ca".to_s), count: 2
  end
end
