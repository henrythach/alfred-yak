#!/usr/bin/env ruby
require 'json'

# Yak class
class Yak
  attr_reader :cache_file

  def initialize
    @cache_file = '.yakcache'
  end

  def todos
    if File.exist?(@cache_file)
      JSON.parse(File.read(@cache_file))
    else
      initialize_cache
    end
  end

  def add_todo(s)
    array = todos.unshift(s)
    save_todos_to_cache(array)
    array
  end

  def remove_todo(s)
    array = todos
    array.delete(s)
    save_todos_to_cache(array)
    array
  end

  def results(query = '')
    items = []
    items << add_todo_result_item(query) unless query.empty?
    items += todos_result_items if todos.any?
    items << empty_result_item if items.empty?
    { items: items }.to_json
  end

  private

  def todos_result_items
    todos.map { |item| { title: item } }
  end

  def add_todo_result_item(query)
    {
      title: query,
      subtitle: 'Add this to the list'
    }
  end

  def empty_result_item
    {
      title: 'No results!',
      subtitle: 'Try adding something to the list'
    }
  end

  def initialize_cache
    return if File.exist?(@cache_file)
    File.open(@cache_file, 'w') do |f|
      f.write [].to_json
    end
    []
  end

  def save_todos_to_cache(stuff = [])
    File.open(@cache_file, 'w') do |f|
      f.write stuff.to_json
    end
  end
end

query = ARGV[0]
yak = Yak.new
puts yak.results(query) if query
