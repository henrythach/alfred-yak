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
      []
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
    {
      items: [{
        title: query.to_s.chomp,
        subtitle: 'Add this to to-do'
      }]
    }.to_json
  end

  private

  def initialize_cache
    return if File.exist?(@cache_file)
    File.open(@cache_file, 'w') do |f|
      f.write [].to_json
    end
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
