#!/usr/bin/env ruby

#TestCases for the lib/myth/filter/filter_confset.rb

require 'test/unit'
require '../lib/myth/filter/filter_confset.rb'

class TestConf < Test::Unit::TestCase
  
  def test_conf()
    
    fp=File.open('../conf/java.conf')
    instance=Myth::Filter::FilterConfset.new(fp)

    ans1=['//']
    ans2=Hash.new
    ans2['/*']='*/'

    assert_equal(ans1,instance.single_line)
    assert_equal(ans2,instance.multi_line)

  end

end
