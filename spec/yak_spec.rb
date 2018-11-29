require 'rspec'
require_relative '../lib/yak'

RSpec.describe Yak do
  let(:yak) { Yak.new }

  context 'no cache initialized' do
    # always delete the cache before all tests
    before(:example) do
      File.delete(yak.cache_file) if File.exist?(yak.cache_file)
      expect(File.exist?(yak.cache_file)).to be false
    end

    # always delete the cache after all tests
    after(:example) do
      File.delete(yak.cache_file) if File.exist?(yak.cache_file)
      expect(File.exist?(yak.cache_file)).to be false
    end

    it 'returns empty items' do
      expect(yak.items).to eq([])
    end

    it 'add an item initializes the cache' do
      yak.add_item('Cook dinner')
      expect(File.exist?(yak.cache_file)).to be true
    end

    it 'add an item saves to the cache' do
      yak.add_item('Eat cake')
      expect(JSON.parse(File.read(yak.cache_file))).to eq(['Eat cake'])
    end

    it 'remove an item saves to the cache' do
      yak.remove_item('Be lazy')
      expect(JSON.parse(File.read(yak.cache_file))).to eq([])
    end

    it 'add an item returns the list of items' do
      expect(yak.add_item('Do homework')).to eq(['Do homework'])
    end

    it 'remove an item returns the list of items' do
      expect(yak.remove_item('Exercise')).to eq([])
    end
  end

  context 'cache initialized' do
    # always delete the cache before all tests
    before(:example) do
      File.open(yak.cache_file, 'w') do |f|
        f.write ['Fix bugs', 'Shower']
      end
    end

    # always delete the cache after all tests
    after(:example) do
      File.delete(yak.cache_file) if File.exist?(yak.cache_file)
      expect(File.exist?(yak.cache_file)).to be false
    end

    it 'add an item to the beginning of list' do
      yak.add_item('Do laundry')
      expect(yak.items).to eq(['Do laundry', 'Fix bugs', 'Shower'])
    end

    it 'remove an item not in list' do
      yak.remove_item('Buy milk')
      expect(yak.items).to eq(['Fix bugs', 'Shower'])
    end

    it 'remove an item from the list' do
      yak.remove_item('Shower')
      expect(yak.items).to eq(['Fix bugs'])
    end
  end
end
