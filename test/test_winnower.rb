#!/usr/bin/env ruby
#Testing the Winnower 

require 'test/unit'

require '../lib/myth/hasher/rollhasher'

require '../lib/myth/winnower/winnower_confset.rb'
require '../lib/myth/winnower/winnower.rb'

class TestWinnower < Test::Unit::TestCase
  include Myth::RollHasher
  
  def test_winnower
        
    fp=File.open('../conf/winnower.conf')

    ins=Myth::Winnowing::WinnowerConfset.new(fp)

    text=File.read('dump2.txt')   

    #Simply call the Hashes     
    @hash_store=calc_hash(text,ins.k,ins.q)  

    File.open('winnowdump', 'w') do |f2|         
      @hash_store.each { |h| f2.print h[:value] , " " }
    end  

    #Call the winnowing algorithm to compare the results
    rb=Myth::Winnowing::RobustWinnower.new(ins,text)
    ans=rb.get_fingerprint   

    File.open('winnowdump', 'a') do |f2| 
      f2.puts "\n"
      ans.each { |h| f2.print h[:value] , " " }  
    end  
    

  end

end
