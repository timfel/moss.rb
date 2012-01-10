#!/usr/bin/env ruby
#Testing the Winnower 

require 'test/unit'

require '../lib/myth/winnower/winnower_confset.rb'
require '../lib/myth/winnower/winnower.rb'

class TestWinnower < Test::Unit::TestCase
  
  def test_winnower
        
    fp=File.open('../conf/winnower.conf')

    ins=Myth::Winnowing::WinnowerConfset.new(fp)

    text=File.read('dump2.txt')   

    rb=Myth::Winnowing::RobustWinnower.new(ins,text)
    ans=rb.robust_winnow
    puts "\n"
    puts "\n"
    print ans.length
    File.open('winnowdump', 'w') do |f2|         
      f2.puts ans
    end  
    

  end

end
