#!/usr/bin/env ruby
#Testing pdf text support

require '../lib/myth/pdfextract/pdf_text_extract.rb'

class PdfTest
  include Myth::PdfTextExtract

  def initialize
    #get the absolute path of file
    @filename=File.expand_path('test.pdf')    
    write_text
  end
  
  def write_text 
    #Store all the content of pdf as text
    extract_text
    File.open('pdfdump.txt', 'w') {|f| f.write(@pdftext) }    
  end
end

PdfTest.new
