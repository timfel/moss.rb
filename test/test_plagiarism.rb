#!/usr/bin/env ruby
#Test whether for two similar documents after winnowing their line numbers are actually making sense
#Input --> Two similar Java file
#Output --> Line Pairs which are Plagiarised form each other

require_relative '../lib/myth.rb'


class TestPlagiarism

  def initialize

    #language noise confile
    lang_confile=File.open(File.expand_path('../../conf/java.conf', __FILE__))
    winnower_confile=File.open(File.expand_path('../../conf/winnower.conf', __FILE__))

    text_one=File.read(File.expand_path('../testcode/one.java', __FILE__))
    text_two=File.read(File.expand_path('../testcode/two.java', __FILE__))

    #Initialize configuration set for NoiseConfig
    lang_ins=Myth::Filter::FilterConfset.new(lang_confile)

    #Initialize ther filter
    filtered_text_one=Myth::Filter::NoiseFilter.new(text_one,lang_ins).get_filtered_text
    filtered_text_two=Myth::Filter::NoiseFilter.new(text_two,lang_ins).get_filtered_text

    File.open(File.expand_path('../testcode/filtered', __FILE__),'w') do |f|
      f.print filtered_text_one
    end

    File.open(File.expand_path('../testcode/filtered2', __FILE__),'w') do |f|
      f.print filtered_text_two
    end


    winnower_confile_ins=Myth::Winnowing::WinnowerConfset.new(winnower_confile)

    #Initialize the winnower
    winnower_ins=Myth::Winnowing::RobustWinnower.new(winnower_confile_ins,filtered_text_one)
    winnower_ins2=Myth::Winnowing::RobustWinnower.new(winnower_confile_ins,filtered_text_two)

    hash_list=winnower_ins.get_fingerprint
    hash_list2=winnower_ins2.get_fingerprint

    puts 'List1'
    hash_list.each { |h| print h[:value], " " }
    print "\n"
    print "\n"
    puts 'List2'
    hash_list2.each { |h| print h[:value] , " " }
    print "\n"

    #A hashtable for detecting common elements between two Hash List
    #For the 1st list we mark all the elements present in table with 'Y'
    #For the next list, we check if hash is in the table.
    #If Yes, we have a  duplicate and we report the two line spans
    common=Hash.new

    hash_list.each do |h|
      common[h[:value]]=h[:line_span]
    end

    #Match the fingerprints

    hash_list2.each do |h|
      if common.include?(h[:value]) then
        print '(', h[:value] , ')' , common[h[:value]] , " " , h[:line_span] , "\n"
      end
    end

  end

end

TestPlagiarism.new
