require 'rails_helper'

RSpec.describe Client, type: :model do
  it 'has valid factory' do
    expect(FactoryBot.create(:client)).to be_valid
  end
end
