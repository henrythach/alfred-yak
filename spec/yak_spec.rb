require 'rspec'
require_relative '../yak'

RSpec.describe Yak do
  context 'from scratch' do
    let(:yak) { Yak.new }
    it 'returns empty items' do
      expect(yak.items).to eq([])
    end
  end

  it 'adds an item' do
    yak = Yak.new(['Add feature', 'Fix bug'])
    yak.add_item('Do laundry')
    expect(yak.items).to eq(['Do laundry', 'Add feature', 'Fix bug'])
  end

  it 'removes an item' do
    yak = Yak.new(['Buy milk', 'Call mom'])
    yak.remove_item('Buy milk')
    expect(yak.items).to eq(['Call mom'])
  end
end
