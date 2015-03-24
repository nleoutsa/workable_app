
class LettersController < ApplicationController

  require 'rtf'
  include RTF
  respond_to :rtf


  DOWNLOAD_PATH = File.join(Rails.root, "app", "views", "letters")

  def index
    @letters = Letter.all

    logger.debug params.inspect
    puts params.inspect
  end

  def show
    @letter = Letter.find(params[:id])

    logger.debug params.inspect
    puts params.inspect
  end


  def new
    @letter = Letter.new

    logger.debug params.inspect
    puts params.inspect
  end














































  def create


    @letter = Letter.new(letter_params)

    logger.debug params.inspect
    puts params.inspect


    if @letter.save

      flash[:notice] = "saved!"
      redirect_to @letter

      document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))


      @co_name = params[:letter][:co_name]
      @co_address_1 = params[:letter][:co_address_1]
      @co_address_2 = params[:letter][:co_address_2]
      @co_city_state_zip = params[:letter][:co_city_state_zip]

      @ap_name = params[:letter][:ap_name]
      @ap_address_1 = params[:letter][:ap_address_1]
      @ap_address_2 = params[:letter][:ap_address_2]
      @ap_city_state_zip = params[:letter][:ap_city_state_zip]

      @pos_title = params[:letter][:pos_title]
      @supervisor = params[:letter][:supervisor]
      @start_date = params[:letter][:start_date]
      @expiry_date = params[:letter][:expiry_date]

      @co_rep = params[:letter][:co_rep]
      @ap_wage = params[:letter][:ap_wage]


####
#      @hrs =
#
#      benefits(checkbox):
#
#      pay_period(dropdown):        weekly
#                                   bi-weekly
#                                   monthly

#      contingencies(checkbox):     drug-test
#                                   background check
#
#
#
#
####
      styles = {}
      styles['Para_Style'] = ParagraphStyle.new
      styles['BOLD'] = CharacterStyle.new
      styles['Justify'] = ParagraphStyle.new
      styles['Justify'].justification = ParagraphStyle::FULL_JUSTIFY

      styles['Para_Style'].left_indent = 400


    #  styles['Char_Style'].font        = Font.new(Font::MODERN, 'Courier')
      styles['BOLD'].bold        = true

      document.paragraph(styles['Para_Style']) do |n1|
        n1.line_break
        n1 << @co_name
        n1.line_break
        n1 << @co_address_1
        n1.line_break if @co_address_2.length > 0
        n1 << @co_address_2 if @co_address_2.length > 0
        n1.line_break
        n1 << @co_city_state_zip
        n1.line_break
        n1.line_break
        n1 << @ap_name
        n1.line_break
        n1 << @ap_address_1
        n1.line_break if @ap_address_2.length > 0
        n1 << @ap_address_2 if @ap_address_2.length > 0
        n1.line_break
        n1 << @ap_city_state_zip
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|

        n1 << "Dear "
        n1 << @ap_name
        n1 << ","
        n1.line_break
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "It is with great excitement that I extend this offer of employment with "
        n1 << @co_name
        n1 << " for the position of "
        n1 << @pos_title
        n1 << ". Provided is a summary of terms and conditions of your anticipated employment with us. If you accept this offer, your start date will be "
        n1 << @start_date
        n1 << " or another mutually agreed upon date and you would report to "
        n1 << @supervisor
        n1 << ". We look forward to adding you to our team."
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Hours and Compensation. "
        end
        n1.line_break
        n1 << "This is a full-time, exempt position requiring approximately "
        n1 << @hrs
        n1 << " per week. "
        n1.line_break
        n1.line_break
        n1 << "Your compensation package includes base pay and the following:"
        n1.line_break
        n1 << "OPTIONS"
        n1.line_break
        n1.line_break
        n1 << "You base salary will be "
        n1 << @ap_wage
        n1 << " delivered "
        n1 << @pay_period
        n1 << ". Standard tax deductions will be made pursuant to state and federal law."
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Conditions for Employment. "
        end
        n1.line_break
        n1 << "This offer is contingent upon proof of eligibility to work in the United States (which must be provided per the terms of the Immigration and Reform Act) and completion of "
        n1.line_break
        n1 << "OPTIONS"
        n1.line_break
        n1 << "You will be required to submit the proper paperwork to confirm your eligibility and tax status. This includes I-9 and W-4 forms, which will be provided."
      end


      document.paragraph(styles['Justify']) do |n1|
        n1 << "You may indicate your agreement with these terms and accept this offer by signing and dating this agreement by "
        n1 << @expiry_date
        n1 << ".  As required by law, your employment with "
        n1 << @co_name
        n1 << " is contingent upon your providing legal proof of your identity and authorization to work in the United States.  This offer is also contingent upon successful completion of a Background check, References check, Drug Test conducted in accordance with applicable federal, state, and local laws.  Upon your acceptance of this employment offer, "
        n1 << @co_rep
        n1 << " will provide you with the necessary paperwork and instructions."
        n1.line_break
      end


      document.paragraph(styles['Justify']) do |n1|
        n1 << "We look forward to hearing from you."
        n1.line_break
        n1 << "Sincerely,"
        n1.line_break
        n1 << @co_rep
        n1.line_break
        n1 << "Signatures:"
        n1.line_break
        n1 << "Company Representative (Sign):  ___________________________________________________"
        n1.line_break
        n1 << "Company Representative (Print): ___________________________________________________"
        n1.line_break
        n1 << "Date:                           ___________________________________________________"
        n1.line_break
        n1.line_break
        n1 << "Applicant (Sign):               ___________________________________________________"
        n1.line_break
        n1 << "Applicant (Print):              ___________________________________________________"
        n1.line_break
        n1 << "Date:                           ___________________________________________________"
        n1.line_break

      end


      File.open('download.rtf', 'w') {|file| file.write(document.to_rtf)} # existing file by this name will be overwritten
      #send_file(File.join(DOWNLOAD_PATH, "create.rtf.rtf_rb"))
      send_file('download.rtf')


    end


  end











































  def edit

    @letter = Letter.find(params[:id])

    logger.debug params.inspect
    puts params.inspect
  end

  def update

    logger.debug params.inspect
    puts params.inspect
    @letter = Letter.find(params[:id])
    if @letter.update_attributes(letter_params)
      flash[:notice] = 'Your letter was updated'
      redirect_to @letter
    else
      render action: 'edit'
    end

  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    redirect_to root_path
  end



############################################################################
############################################################################



  def download


    logger.debug params.inspect
    puts params.inspect
    document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))


    fonts = [Font.new(Font::ROMAN, 'Times New Roman'),
         Font.new(Font::MODERN, 'Courier')]

styles = {}
styles['PS_HEADING']              = ParagraphStyle.new
styles['PS_NORMAL']               = ParagraphStyle.new
styles['PS_NORMAL'].justification = ParagraphStyle::FULL_JUSTIFY
styles['PS_INDENTED']             = ParagraphStyle.new
styles['PS_INDENTED'].left_indent = 300
styles['PS_TITLE']                = ParagraphStyle.new
styles['PS_TITLE'].space_before   = 100
styles['PS_TITLE'].space_after    = 200
styles['CS_HEADING']              = CharacterStyle.new
styles['CS_HEADING'].bold         = true
styles['CS_HEADING'].font_size    = 36
styles['CS_CODE']                 = CharacterStyle.new
styles['CS_CODE'].font            = fonts[1]
styles['CS_CODE'].font_size       = 16

document = Document.new(fonts[0])

document.paragraph(styles['PS_HEADING']) do |p1|
   p1.apply(styles['CS_HEADING']) << 'Example Program'
end

document.paragraph(styles['PS_NORMAL']) do |p1|
   p1 << 'This document is automatically generated using the RTF Ruby '
   p1 << 'library. This serves as an example of what can be achieved '
   p1 << 'in document creation via the library. The source code that '
   p1 << 'was used to generate it is listed below...'
end

document.paragraph(styles['PS_INDENTED']) do |p1|
   n = 1
   p1.apply(styles['CS_CODE']) do |p2|
      File.open('example3.rb') do |file|
         file.each_line do |line|
            p2.line_break
            p2 << "#{n > 9 ? '' : ' '}#{n}   #{line.chomp}"
            n += 1
         end
      end
   end
end

document.paragraph(styles['PS_TITLE']) do |p1|
   p1.italic do |p2|
      p2.bold << 'Listing 1:'
      p2 << ' Generator program code listing.'
   end
end

document.paragraph(styles['PS_NORMAL']) do |p1|
   p1 << "This example shows the creation of a new document and the "
   p1 << "of textual content to it. The example also provides examples "
   p1 << "of using block scope to delimit style scope (lines 40-51)."
end












############################################################################
############################################################################


    File.open('download.rtf', 'w') {|file| file.write(document.to_rtf)} # existing file by this name will be overwritten
    #send_file(File.join(DOWNLOAD_PATH, "create.rtf.rtf_rb"))
    send_file('download.rtf')
  end


  private

  def letter_params
    params.require(:letter).permit(:id, :co_name, :co_address_1, :co_address_2, :co_city_state_zip, :ap_name, :ap_address_1, :ap_address_2, :ap_city_state_zip, :pos_title, :supervisor, :start_date, :expiry_date, :co_email, :ap_wage, :co_rep)
  end


end
