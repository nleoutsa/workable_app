
class LettersController < ApplicationController
  require 'rtf'
  include RTF
  respond_to :rtf

  def new
    @letter = Letter.new
  end

  DOWNLOAD_PATH = File.join(Rails.root, "app", "views", "letters")

  def download

    document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))

############################################################################

count = 15

 styles = {}
 styles['Para_Style'] = ParagraphStyle.new
 styles['Char_Style'] = CharacterStyle.new

 styles['Para_Style'].left_indent = 200
 styles['Char_Style'].font        = Font.new(Font::MODERN, 'Courier')
 styles['Char_Style'].bold        = true

 document.paragraph(styles['Para_Style']) do |n1|
    n1 << "hey there, this should be Times New Roman"
    n1.apply(styles['Char_Style']) do |n2|
       n2 << "count = 0"
       n2.line_break
       n2 << "File.open('file.txt', 'r') do |file|"
       n2.line_break
       n2 << "   file.each_line {|line| count += 1}"
       n2.line_break
       n2 << "end"
       n2.line_break
       n2 << "puts \"File contains #{count} lines.\""
    end
 end












############################################################################


    File.open('download.rtf', 'w') {|file| file.write(document.to_rtf)} # existing file by this name will be overwritten
    #send_file(File.join(DOWNLOAD_PATH, "create.rtf.rtf_rb"))
    send_file('download.rtf')
  end



end
