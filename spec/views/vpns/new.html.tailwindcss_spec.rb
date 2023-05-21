require 'rails_helper'

RSpec.describe "vpns/new", type: :view do
  before(:each) do
    assign(:vpn, Vpn.new())
  end

  it "renders new vpn form" do
    render

    assert_select "form[action=?][method=?]", vpns_path, "post" do
    end
  end
end
