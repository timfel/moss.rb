#!/usr/bin/env ruby
#Read the conf file to get parameters for Winnower

module Myth
  module Winnowing

    class WinnowerConfset

      attr_reader :k, :t, :q
      
      def initialize(confileinstance) 
                
        #Duck typing check :)
        return unless confileinstance.instance_of?(File)
        
        #Parse the winnower.conf file to get the values for k,t,q
        #Skip the comment part,if any                           
        confileinstance.each do |line|               
          
          next if line[0]=='#'
          
          line_array=line.split(" ")  
            
          if line_array[0]=='k'
            @k=line_array[1].to_i                     
          end
          
          if line_array[0]=='t'
            @t=line_array[1].to_i            
          end
          
          if line_array[0]=='q'
            @q=line_array[1].to_i            
          end          
        end
        
      end
    end
    
  end
end
