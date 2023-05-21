require 'rails_helper'

RSpec.describe "vpns/show", type: :view do
  before(:each) do
    assign(:vpn, Vpn.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
