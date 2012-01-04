#!/usr/bin/env ruby

#Filter the source file.
#Remove whitespace, capatilization , punctuations and identifiers
#Also keywords are something which are always the same,so need to be filtered out

require_relative './filter_confset.rb' #Relative require works only for ruby1.9.x

module Myth
  module Filter

    class NoiseFilter
      
      #Invoke the Filter on the file with a confset for different frontend languages
      def initialize(text_to_process,confinstance)       

        #Some duck typing to do :)
        return unless confinstance.instance_of?(Myth::Filter::FilterConfset)
        return unless text_to_process.instance_of?(String)
        
        @text_to_process=text_to_process
        @confinstance=confinstance
        
        #Intially the filtered text is just the initial text,slowly we will apply transformations to remove all the noise
        @filtered_text=String.new
      end

      private

      #For successive filter processes to sucessfull, make @text_to_process a copy of   the filtered text from the first phase
      #The use of the function will be apparent...be patient :)
      def switch_text       
        @text_to_process=@filtered_text
        @filtered_text=""
      end


      def lower_case
        
        line_array=@text_to_process.split("\n")
        for line in line_array do
          line.downcase!
          @filtered_text << line << "\n"
        end
        
        switch_text        
      end

      #We also want to replace every identifier with 'v' (identifier names hardly matter)
      #Regex ninja skills in place :)
      #Also we would skip entire import lines
      #Also skip function calls
      def replace_identifiers      
        #Get a list of line from text String
        line_array=@text_to_process.split("\n")

        for line in line_array do
          
          #Remove any leading whitespaces
          line.lstrip!
          
          #Make a list of words for the line
          split_line=line.split(" ")       

          new_line=""
          text_modified=false
          
          #If the first word of line does not begin with any of @no_indentifier specified by confile, we can change all the words that are "indentifier" by regex to 'v'
        
          unless @confinstance.no_identifiers.include?(split_line[0])  
            text_modified=true
            for word in split_line
              #First regex for a word which begins with a-z or _ and then has any word(w) and then does not end with )
              #We did not consider A-Z coz we have already lowercased our text
              #Second regex for just a single length word indentifier
              if word.match(/^[a-z|_]\w*[^\(]$/)!=nil || word.match(/^[a-z]$/)!=nil
                #puts word
                #unless the keyword list contains this word                       
                unless @confinstance.words_list.include?(word)   
                  word.sub!(word,"v")
                end                
              end
              new_line << " " << word << " "
            end
          end
          
          if text_modified==true
            @filtered_text << new_line << "\n"          
          else
            @filtered_text << line << "\n" 
          end
          
        end
        
        switch_text
      end

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

        switch_text
      end
      
      #Strip off the keywords, chances are they will be repeated all over. Which is quite obvious and points to no plagiarism
      #However no mention about the keywords in
      def remove_keywords
        
        line_array=@text_to_process.split("\n")

        for line in line_array do          
          for keyword in @confinstance.words_list do
            
            #Remove multiple occurences of keyword in line                      
            line.gsub!(keyword,"")             
            
          end         
          
          @filtered_text << line+"\n"
        end        
        switch_text
      end

      #Space all words and symbols which give an insights on different tokens in our code for later phases
      def space_tokens
        
        line_array=@text_to_process.split("\n")

        for line in line_array do

          #There is a pattern we need to observe
          # A line of code like this-->
          # for(c=1;c<1-;c++)
          # We need to sepearte for and (
          # However, for a code like this-->
          # getStuff(), getstuff and ( need to be together so as we can identify it as  a method
          # We cannot strip comments before identifiers as well because we will lose the info on which lines are package imports/library includes or declaration line
          #Hence our keywords need some special treatment
          line_split=line.split(" ")   
          line=""
          
          for word in line_split           
            for keyword in @confinstance.words_list do                  
              if word.include?(keyword)
                new_keyword=" " << keyword << " "
                word.sub!(keyword,new_keyword)
              end
            end  
            line << word
          end   
          
          #Space'commas' and semicolon          
          line.gsub!(","," , ")
          line.gsub!(";"," ; ")               
      

          line.gsub!("{"," { ")
          line.gsub!("}"," } ")
          line.gsub!("["," [ ")
          line.gsub!("]"," ] ")
          line.gsub!("(","( ")  #keep attached to method but seperate from parameter within
          line.gsub!(")"," ) ")
          line.gsub!("+"," + ") #Case when c++ c + +
          line.gsub!("-"," - ")
         
          #For all words with =,:,<,> sticked together we can seperate the identifier.methodname() or identifier:list with a space so as they can be later properly identified as a sepearte varibale
          #We need them at this stage to differentiate between different tokens, so they will be removed in a later stage
          line.gsub!("="," = ")
          line.gsub!(":"," : ")
          line.gsub!("<"," < ")
          line.gsub!(">"," > ")
          line.gsub!(".",". ")         
          

          #Remove @                     
          line.gsub!("@","")                             

          @filtered_text << line+"\n"         
        end

        switch_text

      end

      #Get rid of all now useless symbols
      def remove_punctuations       
        
        line_array=@text_to_process.split("\n")
        
        for line in line_array do
                   
          line.gsub!(",","")
          line.gsub!(";","")               
      

          line.gsub!("{","")
          line.gsub!("}","")
          line.gsub!("[","")
          line.gsub!("]","")
          line.gsub!(")","")
          line.gsub!("(","")
         
          line.gsub!(":","")
          line.gsub!(".","")  
          line.gsub!("\"","")         

          @filtered_text << line+"\n"
        end
        
        switch_text
      end

      def remove_whitespaces
              
        line_array=@text_to_process.split("\n")           
               
        for line in line_array do                    
          
          #Remove all tabs and whitespaces        
          line.gsub!("\t","") 
          line.gsub!(" ","")         

          #Hasher needs a line number to associate with all hashes so we should not be Removing \r and \n
          #But we can remove \r and \n if the line is empty(no text)
          if line==''          
            next #do not include the blankline+'\n' in filtered text
          end

          @filtered_text << line << "\n"  
        end
      end
      
      public
      
      #Calling a series of private methods to filter out the noise
      def get_filtered_text

        lower_case
        
        remove_comments

        space_tokens
        
        replace_identifiers           
        
        #Remove keyword after identifiers because we do not remove identifiers from certain lines with Keywords like 'import' or 'package'
        remove_keywords 

        remove_punctuations                          
        
        remove_whitespaces    

        #finally return the filtered text 
        return @filtered_text
      end
      
    end
  end
end
