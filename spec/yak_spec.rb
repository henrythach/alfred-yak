require 'rspec'
require_relative '../lib/yak'

RSpec.describe Yak do
  let(:yak) { Yak.new }

  context 'empty cache' do
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

    it 'returns empty todos' do
      expect(yak.todos).to eq([])
    end

    it 'add a todo initializes the cache' do
      yak.add_todo('Cook dinner')
      expect(File.exist?(yak.cache_file)).to be true
    end

    it 'add a todo saves to the cache' do
      yak.add_todo('Eat cake')
      expect(JSON.parse(File.read(yak.cache_file))).to eq(['Eat cake'])
    end

    it 'remove a todo saves to the cache' do
      yak.remove_todo('Be lazy')
      expect(JSON.parse(File.read(yak.cache_file))).to eq([])
    end

    it 'add a todo returns the list of todos' do
      expect(yak.add_todo('Do homework')).to eq(['Do homework'])
    end

    it 'remove a todo returns the list of todos' do
      expect(yak.remove_todo('Exercise')).to eq([])
    end

    context 'with no query' do
      let(:query) { '' }

      it 'returns a "no results" results' do
        expected_results = {
          items: [{
            title: 'No results!',
            subtitle: 'Try adding something to the list'
          }]
        }.to_json
        expect(yak.results(query)).to eq(expected_results)
      end
    end

    context 'with a query' do
      let(:query) { 'Get oil change' }

      it 'returns two results' do
        expected_results = {
          items: [{
            title: 'Get oil change',
            subtitle: 'Add this to the list'
          }]
        }.to_json
        expect(yak.results(query)).to eq(expected_results)
      end
    end
  end

  context 'non-empty cache' do
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

    it 'add a todo to the beginning of list' do
      yak.add_todo('Do laundry')
      expect(yak.todos).to eq(['Do laundry', 'Fix bugs', 'Shower'])
    end

    it 'remove a todo not in list' do
      yak.remove_todo('Buy milk')
      expect(yak.todos).to eq(['Fix bugs', 'Shower'])
    end

    it 'remove a todo from the list' do
      yak.remove_todo('Shower')
      expect(yak.todos).to eq(['Fix bugs'])
    end

    context 'with no query' do
      let(:query) { '' }

      it 'returns a "no results" results' do
        expected_results = {
          items: [{
            title: 'Fix bugs'
          }, {
            title: 'Shower'
          }]
        }.to_json
        expect(yak.results(query)).to eq(expected_results)
      end
    end

    context 'with a query' do
      let(:query) { 'Get oil change' }

      it 'returns two results' do
        expected_results = {
          items: [{
            title: 'Get oil change',
            subtitle: 'Add this to the list'
          }, {
            title: 'Fix bugs'
          }, {
            title: 'Shower'
          }]
        }.to_json
        expect(yak.results(query)).to eq(expected_results)
      end
    end
  end
end
