#!/usr/bin/env ruby
require 'json'

# Yak class
class Yak
  def initialize
    @cache_file = '.yakcache'
  end

  def results(query = '')
    {
      items: [{
        title: query,
        subtitle: "Add '#{query}' to list",
        arg: query,
        autocomplete: 'Title one'
      }]
    }.to_json
  end
end

query = ARGV[0]
yak = Yak.new
puts yak.results(query)
