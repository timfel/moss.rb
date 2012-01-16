#!/usr/bin/env ruby
#Extracting text from Pdf for assignments other then plain text

#Using pdf-reader gem 
#https://github.com/yob/pdf-reader
#Extract all the text as a String
#The gem supports a pagebypage text output for a pdf

require 'pdf/reader'

module Myth
  module PdfTextExtract
    
    attr_reader :pdftext
    
    def extract_text   
      @pdftext=String.new
      #Page by page text read
      PDF::Reader.open(@filename) do |reader|
        reader.pages.each do |page|         
          @pdftext << page.text
        end
      end    
    end

  end
end
