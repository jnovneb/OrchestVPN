require 'rails_helper'

RSpec.describe "vpns/edit", type: :view do
  let(:vpn) {
    Vpn.create!()
  }

  before(:each) do
    assign(:vpn, vpn)
  end

  it "renders the edit vpn form" do
    render

    assert_select "form[action=?][method=?]", vpn_path(vpn), "post" do
    end
  end
end
