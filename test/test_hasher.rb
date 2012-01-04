#!/usr/bin/env ruby

#Unit Testing for hasher

require 'test/unit'
require '../lib/myth/hasher/rollhasher.rb'

class TextHasher < Test::Unit::TestCase
  
  include Myth::RollHasher
  
  def test_hasher
    text=File.read('./dump2.txt')   
    
    hash_store=calc_hash(text,5,101)
    
    hash_store.each do |hash|
      print "( " , hash[:value] , " " , hash[:line_span] , " )\n"      
    end

  end

end
