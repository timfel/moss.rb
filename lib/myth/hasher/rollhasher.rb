#!/usr/bin/env ruby
#Designing a rolling hash function
#Inspired by Rabin-Karp Algorithm

module Myth
  module RollHasher
    
    #Defining a Hash Structure
    #A hash is a integer value + line numbers where the word for this hash spaned(could be 2 lines)
    Struct.new('Hash',:value,:line_span)

    #Defining another custom object Index
    #'Index' is a (ruby range,linecount) object
    #span_store keeps the 'Index' stored in a array
    #As the span_store is build incrementally from the text, we could binary search to quickly find which range our beginchar and endchar fall in and calc the corresponding line span from the object and make the 'Hash' object
    Struct.new('Index',:index_range,:line_number)    
    
    @@span_store=Array.new    
    
    def find_line(index)
      begin_index=0      
      end_index=@@span_store.length-1    
      
      #If everything works as planned we will find the appropriate
      while begin_index<=end_index do
        
        mid=(begin_index+end_index)/2
        
        index_object=@@span_store[mid]
        
        if index_object[:index_range].include?(index)
          return index_object[:line_number]
        elsif index<(index_object[:index_range].min)  #go to lower ranges
          end_index=mid-1
        else
          begin_index=mid+1
        end
      end    
    end

    #For hashing a piece of text we ned two sets of parameters
    #k-->For buildinf units of k grams hashes  
    #q-->Prime which lets calculations stay within range
    def calc_hash(text_to_process,k,q)
      
      @@span_store.clear
      
      radix=34
      line_number=1

      highorder=(radix**(k-1))%q     

      #Storing all the hashes generated for a text file
      hash_store=Array.new
      
      #Before we apply any of the Robin Karp Algorithm...
      #Strip off the newlines so that an easy readable implementation of Algorithm follows
      #Get an arrray from text with individual lines
      line_list=text_to_process.split("\n")
      index=0
      line_count=1   
      
      for line in line_list do

        #this was a blank line and is only usefull for the purpose of maintaining line number count, the text '$' has otherwise no oder significance.
        if line=='$'
          line_count+=1
          next
        end
          
        #calc length of line 
        line_length=line.length         
        
        #index...index+line.length is 
        if index==0
          index_range=index..index+line.length-1
        else
          index_range=index...index+line.length
        end         
        
        #Store in our DS        
        @@span_store.push(Struct::Index.new(index_range,line_count))       
        index=index+line_length
        line_count+=1
      end            
      
      #We dont need newlines anymore :)
      #A clean Rabin karp algorithm can now be implemented, perhaps this makes this implementation 'neat' and worth sticking onto unlike the previous one in VC.      
      text_to_process.gsub!("\n","")
      text_to_process.gsub!("$","")
      text_length=text_to_process.length

      text_hash=0
      
      #Preprocessing from RobinKarp Algorithm
      for c in 0...k do
        text_hash=(radix*text_hash+text_to_process[c].ord)%q
      end

      #find what line_span does our Preprocessed text lie in
      #line_span is a range as well
      begin_line=find_line(0)
      end_line=find_line(k)     
      
      line_span=(begin_line..end_line)           
 
      #Make a new Hash Object
      hash=Struct::Hash.new(text_hash,line_span)
      hash_store.push(hash)  #Store it in our hash store

      loop=text_length-k     
         
      #The main loop for Rabin Karp
      for c in 0...loop do   
        text_hash=(radix*(text_hash-text_to_process[c].ord*highorder)+(text_hash[c+k].ord))%q
        begin_line=find_line(c+1)
        end_line=find_line(c+k)

        line_span=begin_line..end_line

        #Make a new Hash Object
        hash=Struct::Hash.new(text_hash,line_span)
        hash_store.push(hash)  #Store it in our hash store
      end      
      return hash_store
    end    
    
  end
end
