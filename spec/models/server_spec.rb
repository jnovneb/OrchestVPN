require 'rails_helper'

RSpec.describe Server, type: :model do
  it 'has valid factory' do
    expect(FactoryBot.create(:server)).to be_valid
  end
end
