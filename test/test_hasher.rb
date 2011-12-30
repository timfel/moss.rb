#!/usr/bin/env ruby

#Unit Testing for hasher

require 'test/unit'
require '../lib/myth/hasher/hasher.rb'

class TextHasher < Test::Unit::TestCase
  
  include Myth::Hasher
  
  def test_hasher
    text=File.read('./dump.txt')   
    
    puts text
    puts calc_hash(text,5,101)
  end

end
