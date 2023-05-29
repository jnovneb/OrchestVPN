require 'rails_helper'

RSpec.describe "servers/new", type: :view do
  before(:each) do
    assign(:server, Server.new(
      name: "MyString",
      addr: "MyString",
      credentials: "MyString",
      hostkey: "MyString",
      CA: "MyString"
    ))
  end

  it "renders new server form" do
    render

    assert_select "form[action=?][method=?]", servers_path, "post" do

      assert_select "input[name=?]", "server[name]"

      assert_select "input[name=?]", "server[addr]"

      assert_select "input[name=?]", "server[credentials]"

      assert_select "input[name=?]", "server[hostkey]"

      assert_select "input[name=?]", "server[CA]"
    end
  end
end
