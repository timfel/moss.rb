#!/usr/bin/env ruby

#Configure set to use.
#A configure set is a keywords set+comment type specific to the frontend ( Java,Ruby,VHDL)
#Text can be of two types 'Essay' or 'Code'
#Essay --> any usual text assignment
#Code  --> any source code or software assignment
#If a '.conf' file with invalid syntax is specified, the code may break. Some checks needed.

module Myth
  module Filter
    
    class FilterConfset

      attr_accessor :words_list, :single_line, :multi_line, :no_identifiers

      #Get a configuration file
      def initialize(confileinstance)

        #Duck typing check :)
        return unless confileinstance.instance_of?(File)
        
        #An Array based DS maintaining Keywords list
        @words_list=Array.new 

        #A DS maintaining list of String which mark the beginning of single line comment in the programming language
        @single_line=Array.new
        
        #A DS maintaining pair of symbols as Hash which mark the beginning and end of multi line comment in the programming language
        @multi_line=Hash.new

        #boolean value to check if we are in the comment section of the conf file yet
        in_comment_section=false
        #boolean to check if we are in multicomment block
        in_multi_comment_section=false

        #Reading the file line by line
        confileinstance.each do |line|
          
          #Remove trailing newlines
          line.chomp!

          #Check if Essay type, if yes then we dont need to go through all the pain of parsing all the parameters
          break if line=="Essay:"                     

          #Skip the line which says 'Keywords:'
          next if line=='Keywords:'

          line_split=line.split(" ")
          if line_split[0]=="NoIdentifier:"
            in_comment_section=true
            @no_identifiers=line_split[1...line_split.length]
          end

          #Once we encounter the line 'Comments:' we know we are in comments block
          if line=='Comments:'
            in_comment_section=true
            next
          end

          if line=='Multi:'
            in_multi_comment_section=true
            next
          end

          #Add the words as kewords if not in comment block
          @words_list.push(line) if in_comment_section==false 
          
          #Add the comment demarkator to single_line DS 
          @single_line.push(line) if in_comment_section==true && in_multi_comment_section==false 

          #Add the comment demarkator to multi_line DS if in_multi_comment_section? is true
          #The two adjancent indexes will contain the begin and end demarkator
          if in_multi_comment_section==true then
            comment_starter=line.split
            @multi_line[comment_starter[0]]=[comment_starter[1]]
          end
        end
        
        confileinstance.close
        
      end
      
    end    
  end
end
