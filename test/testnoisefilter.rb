#!/usr/bin/env ruby

#Testing the Noise Filter
#Unit Tests FTW!

require 'test/unit'
require '../lib/myth/filter/filter_noise.rb'
require '../lib/myth/filter/confset.rb'

class TestNoiseFilter < Test::Unit::TestCase

  def test_remove_comments()

    fp=File.open('../conf/java.conf')

    confinstance=Myth::Filter::Confset.new(fp)

    text_contents=File.read('./Code.java')

    instance=Myth::Filter::NoiseFilter.new(text_contents,confinstance)
    instance.filter
    
    #Write the text after filtering
    File.open('dump.txt','w') { |fp| fp.puts(instance.filtered_text) }

  end

end


  
