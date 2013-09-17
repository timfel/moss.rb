#!/usr/bin/env ruby

#Testing the Noise Filter
#Unit Tests FTW!

require 'test/unit'
require '../lib/myth/filter.rb'

class TestNoiseFilter < Test::Unit::TestCase

  def test_remove_comments()

    fp=File.open('../conf/java.conf')

    confinstance=Myth::Filter::FilterConfset.new(fp)

    text_contents=File.read('./Code.java')

    instance=Myth::Filter::NoiseFilter.new(text_contents,confinstance)
    ans=instance.get_filtered_text

    #Write the text after filtering
    File.open('dump.txt','w') { |fp| fp.puts(ans) }

    ##ANOTHER RANDOM TEST FROM PASTEBIN
    text_contents2=File.read('./pastebin.java')
    instance2=Myth::Filter::NoiseFilter.new(text_contents2,confinstance)
    ans2=instance2.get_filtered_text

    #Write the text after filtering
    File.open('dump2.txt','w') { |fp| fp.puts(ans2) }

  end

end
