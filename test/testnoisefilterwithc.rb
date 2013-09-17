#!/usr/bin/env ruby

#Testing the Noise Filter
#Unit Tests FTW!

require 'test/unit'
require '../lib/myth/filter.rb'

class TestNoiseFilter < Test::Unit::TestCase

  def test_remove_comments()

    fp=File.open('../conf/c.conf')

    confinstance=Myth::Filter::FilterConfset.new(fp)

    text_contents=File.read('./cfile.c')

    instance=Myth::Filter::NoiseFilter.new(text_contents,confinstance)
    ans=instance.get_filtered_text

    #Write the text after filtering
    File.open('Cdump.txt','w') { |fp| fp.puts(ans) }

  end

end
