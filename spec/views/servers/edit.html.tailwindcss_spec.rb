require 'rails_helper'

RSpec.describe "servers/edit", type: :view do
  let(:server) {
    Server.create!(
      name: "MyString",
      addr: "MyString",
      credentials: "MyString",
      hostkey: "MyString",
      CA: "MyString"
    )
  }

  before(:each) do
    assign(:server, server)
  end

  it "renders the edit server form" do
    render

    assert_select "form[action=?][method=?]", server_path(server), "post" do

      assert_select "input[name=?]", "server[name]"

      assert_select "input[name=?]", "server[addr]"

      assert_select "input[name=?]", "server[credentials]"

      assert_select "input[name=?]", "server[hostkey]"

      assert_select "input[name=?]", "server[CA]"
    end
  end
end
