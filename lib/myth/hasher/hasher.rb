#!/usr/bin/env ruby
#Designing a rolling hash function.
#Inspired from the Rabin-Karp Algorithm

module myth
  module hasher
    
    #Defining a Hash Structure
    #A hash is a integer value + line number where the word for this hash existed in the source file
    Struct.new('Hash',:value,:line_number)
    
    #Do I really need a class???
    class Hasher
      
      private

      #Calulate hashes for 
      def calc_hash
        

      end
