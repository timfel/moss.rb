#!/usr/bin/env ruby
#Heart of Plagiarsim Detection
#Implementation of Robust Winnowing

require_relative '../hasher/rollhasher.rb'

module Myth
  module Winnowing
    
    class RobustWinnower      
      include Myth::RollHasher
      
      def initialize(configinstance,text_to_process) 
        
        return unless configinstance.instance_of? Myth::Winnowing::WinnowerConfset

        #Extracting values out of configinstance
        @k_gram=configinstance.k
        @guarentee_threshold=configinstance.t
        @prime=configinstance.q
        @window_size=@guarentee_threshold-@k_gram+1
        @text_to_process=text_to_process      

        #Final set of Hashes selected
        @finger_print=Array.new        
      end          

      public

      def robust_winnow        
        #Get the hash list for the text
        @hash_store=calc_hash(@text_to_process,@k_gram,@prime)
                        
        #Group the Hashes into window of size '@window_size'
        #In each window select the minimum hash value. If possible break ties by selecting the same hash as the window one position left
        #If not select the rightmost minimal hash
        
        processed_element=0
        hash_relative_index=-1
        minimum_hash=0
        window=Array.new

        while processed_element<@hash_store.length do

          if hash_relative_index<0 then  # A new window span to begin            
            if processed_element==0 then
              window=@hash_store[0..@window_size-1]
              processed_element+=@window_size
            else
              window=@hash_store[processed_element-(@window_size-1)..processed_element]
              processed_element+=1            
            end
            #find the minimum element in the window with its index
            minimum_hash=window[0][:value]
            window.each_index do |index|              
              if window[index][:value]<=minimum_hash then
                minimum_hash=window[index][:value]
                hash_relative_index=index
              end              
            end
            @finger_print.push(minimum_hash)
          else
            #check if the new element added to the window is lesser or equal         
            if @hash_store[processed_element][:value]<=minimum_hash
              minimum_hash=@hash_store[processed_element][:value]
              @finger_print.push(minimum_hash)
              hash_relative_index=@window_size-1  # the relative position is now @window_size-1 in the window array
            end
            processed_element+=1
          end      
          hash_relative_index-=1
        end
        return @finger_print
      end      
    
    end

  end
end
