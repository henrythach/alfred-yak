#!/usr/bin/env ruby
require 'json'

# Yak class
class Yak
  attr_reader :items

  def initialize(items = [])
    @cache_file = '.yakcache'
    @items = items
  end

  def add_item(s)
    @items.unshift(s)
  end

  def remove_item(s)
    @items.delete(s)
  end

  def results(query = '')
    {
      items: [{
        title: query.to_s.chomp,
        subtitle: 'Add this to to-do'
      }]
    }.to_json
  end
end

query = ARGV[0]
yak = Yak.new
puts yak.results(query) if query
