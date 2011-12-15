#!/usr/bin/env ruby

#Filter the source file.
#Remove whitespace, capatilization , punctuations and identifiers
#Also keywords are something which are always the same,so need to be filtered out

require_relative './confset.rb' #Relative require works only for ruby1.9.x

module Myth
  module Filter

    class NoiseFilter

      attr_accessor :filtered_text
      
      #Invoke the Filter on the file with a confset for different frontend languages
      def initialize(text_to_process,confinstance)       

        #Some duck typing to do :)
        return unless confinstance.instance_of?(Myth::Filter::Confset)
        return unless text_to_process.instance_of?(String)
        
        @text_to_process=text_to_process
        @confinstance=confinstance
        
        #Intially the filtered text is just the initial text,slowly we will apply transformations to remove all the noise
        @filtered_text=String.new
      end

      private

      #If a single line comment then we need to ignore this particular line
      #If a multigline comment begins then we need to ignore the lines till we find the end 

      #Go line by line and strip off the comments
      def remove_comments
        
        #Split all lines and put them in an array
        line_array=@text_to_process.split("\n")

        #We assume the line is not part of multi line comments (hence false)
        #The initialization cannot be inside loop, as multiline comments can span among multiple lines 
        
        multi_line_type=false

        for line in line_array do
          
          #Check if we already a part of multiline comment
          unless multi_line_type==false
            
            #look for end of multiline comment
            if line.include?(@confinstance.multi_line[multi_line_type][0])
              multi_line_type=false  #the multi line span end here itself
              next #goto next line
            else
              next
            end
          end

          #we assume initially we have no single line comments on our way
          single_line_exist=false         
          
          #For all single comment type, check if the 'line' begins with any single line comment
          for comment in @confinstance.single_line do

            single_comment_length=comment.length
            
            #match the first 'comment.length' characters in line with comment
            prefix=line.slice(0,single_comment_length+1)

            #if we have a single line comment in the beginning of the line 
            if prefix==comment
              single_line_exist=true
              break # break out!
            end

            #for single line comments that start somewhere in  mid
            if line.include?(comment)              
              line.slice!(line.index(comment),line.length)              
            end
            
          end
      

          #for all multiline comment types beginning symbols(so keys)        
          for comment in @confinstance.multi_line.keys do
            
            multi_comment_length=comment.length
 
            #match the first 'comment.length' characters in line with comment
            prefix=line.slice(0,multi_comment_length)
           
            #the line is beginning a multiline comment
            if prefix==comment
              multi_line_type=prefix
            end
          end


          #So if its not a single line comment or part of a  multiline comment part we can add it to filtered text
          
          if single_line_exist==false && multi_line_type==false
            @filtered_text << line << "\n" 
          end

          
          #Check if the end of multicomment is present in the same line somewhere
          unless multi_line_type==false

            #look for end of multiline comment
            if line.include?(@confinstance.multi_line[multi_line_type][0])
              multi_line_type=false  #the span end in this line itself
            end
          end
          
        end

      end
      
      def remove_keywords
        
      end
      
      def remove_whitespace
        #This is one of the easiest part ;)
        
      end
      
      #We also want to replace every identifier with 'V' (identifier names hardly matter)
      #Regex ninja skills in place :)
      def replace_identifiers       

      end
      
      public
      
      #Calling a series of private methods to filter out the noise
      def filter
        
        remove_comments
        
        remove_keywords
        
        replace_identifiers

        remove_whitespace
        
      end

    end

  end
end
