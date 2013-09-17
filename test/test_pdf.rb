#!/usr/bin/env ruby
#Testing pdf text support

require_relative '../lib/myth/pdfextract/pdf_text_extract.rb'

class PdfTest
  include Myth::PdfTextExtract

  def initialize
    #get the absolute path of file
    @filename=File.expand_path('../test.pdf', __FILE__)
    write_text
  end

  def write_text
    #Store all the content of pdf as text
    extract_text
    File.open(File.expand_path('../pdfdump.txt', __FILE__), 'w') {|f| f.write(@pdftext) }
  end
end

PdfTest.new
