require 'rails_helper'

RSpec.describe Vpn, type: :model do
  it 'has valid factory' do
    expect(FactoryBot.create(:vpn)).to be_valid
  end
end
