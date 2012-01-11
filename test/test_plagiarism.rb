#!/usr/bin/env ruby
#Test whether for two similar documents after winnowing their line numbers are actually making sense
#Input --> Two similar Java file
#Output --> Line Pairs which are Plagiarised form each other

require '../lib/myth/filter/filter_confset.rb'
require '../lib/myth/filter/filter_noise.rb'

require '../lib/myth/hasher/rollhasher.rb'
require '../lib/myth/winnower/winnower_confset.rb'
require '../lib/myth/winnower/winnower.rb'


class TestPlagiarism

  def initialize        

    #language noise confile
    lang_confile=File.open('../conf/java.conf')
    winnower_confile=File.open('../conf/winnower.conf')

    text_one=File.read('testcode/one.java')
    text_two=File.read('testcode/two.java')

    #Initialize configuration set for NoiseConfig
    lang_ins=Myth::Filter::FilterConfset.new(lang_confile)

    #Initialize ther filter
    filtered_text_one=Myth::Filter::NoiseFilter.new(text_one,lang_ins).get_filtered_text
    filtered_text_two=Myth::Filter::NoiseFilter.new(text_two,lang_ins).get_filtered_text
    
    File.open('testcode/filtered','w') do |f|      
      f.print filtered_text_two
    end

    #Initialize configuration for Winnower
    winnower_confile_ins=Myth::Winnowing::WinnowerConfset.new(winnower_confile)

    #Initialize the winnower
    winnower_ins=Myth::Winnowing::RobustWinnower.new(winnower_confile_ins,filtered_text_one)
    winnower_ins2=Myth::Winnowing::RobustWinnower.new(winnower_confile_ins,filtered_text_two)

    puts 'Winnowing text1'
    hash_list=winnower_ins.get_fingerprint
    puts 'Winnowing text2'
    hash_list2=winnower_ins2.get_fingerprint

    puts 'List1'
    hash_list.each { |h| print h[:value], " " } 
    print "\n"
    puts 'List2'
    hash_list2.each { |h| print h[:value], " " }
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
