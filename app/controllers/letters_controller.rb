
class LettersController < ApplicationController
  require 'rtf'
  include RTF

  def show
  end

  def export
    @document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))
    @document.paragraph do |p|
       p << "This is the first sentence in the paragraph. "
       p << "This is the second sentence in the paragraph. "
       p << "And this is the third sentence in the paragraph."
    end
    File.open('my_document.rtf', 'w') {|file| file.write(@document.to_rtf)} # existing file by this name will be overwritten
    #send_file @document.to_s, :type=>"text/richtext"

  end



end
