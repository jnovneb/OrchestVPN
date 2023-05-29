require 'rails_helper'

RSpec.describe "clients/new", type: :view do
  before(:each) do
    assign(:client, Client.new(
      vpn: "MyString",
      name: "MyString",
      desc: "MyString",
      cert: "MyString",
      options: "MyString"
    ))
  end

  it "renders new client form" do
    render

    assert_select "form[action=?][method=?]", clients_path, "post" do

      assert_select "input[name=?]", "client[vpn]"

      assert_select "input[name=?]", "client[name]"

      assert_select "input[name=?]", "client[desc]"

      assert_select "input[name=?]", "client[cert]"

      assert_select "input[name=?]", "client[options]"
    end
  end
end
