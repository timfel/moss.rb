#!/usr/bin/env ruby
#Testing the Winnower

require 'test/unit'

require_relative '../lib/myth.rb'

class TestWinnower < Test::Unit::TestCase
  include Myth::Hasher::RollHasher

  def test_winnower

    fp=File.open(File.expand_path('../../conf/winnower.conf', __FILE__))

    ins=Myth::Winnowing::WinnowerConfset.new(fp)

    text=File.read(File.expand_path('../dump2.txt', __FILE__))

    #Simply call the Hashes
    @hash_store = calc_hash(text,ins.k,ins.q)

    File.open(File.expand_path('../winnowdump', __FILE__), 'w') do |f2|
      @hash_store.each { |h| f2.print h[:value] , " " }
    end

    #Call the winnowing algorithm to compare the results
    rb=Myth::Winnowing::RobustWinnower.new(ins,text)
    ans=rb.get_fingerprint

    File.open(File.expand_path('../winnowdump', __FILE__), 'a') do |f2|
      f2.puts "\n"
      ans.each { |h| f2.print h[:value] , " " }
    end
  end
end
