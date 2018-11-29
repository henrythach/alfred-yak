#!/usr/bin/env ruby
require 'json'

# Yak class
class Yak
  attr_reader :cache_file

  def initialize
    @cache_file = '.yakcache'
  end

  def items
    if File.exist?(@cache_file)
      JSON.parse(File.read(@cache_file))
    else
      initialize_cache
    end
  end

  def add_item(s)
    array = items.unshift(s)
    save_items_to_cache(array)
    array
  end

  def remove_item(s)
    array = items
    array.delete(s)
    save_items_to_cache(array)
    array
  end

  def results(query = '')
    return results_json if items.any?
    return empty_results_json if query.empty?
    {
      items: [{
        title: query,
        subtitle: 'Add this to the list'
      }]
    }.to_json
  end

  private

  def results_json
    {
      items: items.map { |item| { title: item} }
    }.to_json
  end

  def empty_results_json
    {
      items: [{
        title: 'No results!',
        subtitle: 'Try adding something to the list'
      }]
    }.to_json
  end

  def initialize_cache
    return if File.exist?(@cache_file)
    File.open(@cache_file, 'w') do |f|
      f.write [].to_json
    end
    []
  end

  def save_items_to_cache(stuff = [])
    File.open(@cache_file, 'w') do |f|
      f.write stuff.to_json
    end
  end
end

query = ARGV[0]
yak = Yak.new
puts yak.results(query) if query
