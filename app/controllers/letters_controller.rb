
class LettersController < ApplicationController

#  before_action :load_letter, only: [:show, :update, :edit, :destroy]
#  before_action :load_wizard, only: [:new, :edit, :create, :update]


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
  #  @letter = @wizard.object

    logger.debug params.inspect
    puts params.inspect
  end

  def create


    @letter = Letter.new(letter_params)

    logger.debug params.inspect
    puts params.inspect


    if @letter.save

      flash[:notice] = "saved!"
      @letter.subscribe
      flash[:notice] = "emailed!"
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


      styles = {}
      styles['Para_Style'] = ParagraphStyle.new
      styles['Char_Style'] = CharacterStyle.new
      styles['Justify'] = ParagraphStyle.new
      styles['Justify'].justification = ParagraphStyle::FULL_JUSTIFY

      styles['Para_Style'].left_indent = 400


    #  styles['Char_Style'].font        = Font.new(Font::MODERN, 'Courier')
      styles['Char_Style'].bold        = true

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
        n1 << @co_name
        n1 << " is pleased to offer you employment on the following terms:"
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "1. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Position. "
        end
        n1 << "Your title will be "
        n1 <<  @pos_title
        n1 << ", and you will report to "
        n1 << @supervisor
        n1 << ".  Your start date is "
        n1 << @start_date
        n1 << ".  This is a part-time position. While you render services to "
        n1 << @co_name
        n1 << ", you are free to engage in other employment, consulting, or other business activity as long as it does not create a conflict of interest with "
        n1 << @co_name
        n1 << ".  By signing this letter agreement, you confirm to "
        n1 << @co_name
        n1 << " that you have no contractual commitments or other legal obligations that would prohibit you from performing your duties for "
        n1 << @co_name
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "2. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Cash Compensation. "
        end
        n1 << "The Company will pay hourly at a rate of $"
        n1 << @ap_wage
        n1 << ", payable in accordance with "
        n1 << @co_name
        n1 << "'s standard payroll schedule.  This wage will be subject to adjustment pursuant to "
        n1 << @co_name
        n1 << "’s employee compensation policies in effect from time to time."
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "3. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Employee Benefits. "
        end
        n1 << "As a part-time employee of "
        n1 << @co_name
        n1 << ", you will not be eligible for Company-sponsored benefits or paid vacation."
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "4. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Proprietary Information and Inventions Agreement. "
        end
        n1 << "Like all Company employees, you will be required, as a condition of your employment with "
        n1 << @co_name
        n1 << " to sign "
        n1 << @co_name
        n1 << "’s standard Proprietary Information and Inventions Agreement."
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "5. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Employment Relationship. "
        end
        n1 << "Employment with "
        n1 << @co_name
        n1 << " is for no specific period of time.  Your employment with "
        n1 << @co_name
        n1 << " will be \"at will,\" meaning that either you or "
        n1 << @co_name
        n1 << " may terminate your employment at any time and for any reason, with or without cause.  Any contrary representations that may have been made to you are superseded by this letter agreement.  This is the full and complete agreement between you and "
        n1 << @co_name
        n1 << " on this term.  Although your job duties, title, compensation and benefits, as well as "
        n1 << @co_name
        n1 << "’s personnel policies and procedures, may change from time to time, the “at will” nature of your employment may only be changed in an express written agreement signed by you and a duly authorized officer of "
        n1 << @co_name
        n1 << " (other than you)."
        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "6. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Tax Matters. "
        end
        n1.line_break
        n1.line_break
        n1 << "(a) "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Withholding. "
        end
        n1 << "All forms of compensation referred to in this letter agreement are subject to reduction to reflect applicable withholding and payroll taxes and other deductions required by law."
        n1.line_break
        n1.line_break
        n1 << "(b) "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Tax Advice. "
        end
        n1 << "You are encouraged to obtain your own tax advice regarding your compensation from "
        n1 << @co_name
        n1 << ".  You agree that "
        n1 << @co_name
        n1 << " does not have a duty to design its compensation policies in a manner that minimizes your tax liabilities, and you will not make any claim against "
        n1 << @co_name
        n1 << " or its Board of Directors related to tax liabilities arising from your compensation."

        n1.line_break

      end

      document.paragraph(styles['Justify']) do |n1|
        n1 << "7. "
        n1.apply(styles['Char_Style']) do |n2|
           n2 << "Interpretation, Amendment and Enforcement. "
        end
        n1 << "This letter agreement constitutes the complete agreement between you and "
        n1 << @co_name
        n1 << ", contains all of the terms of your employment with "
        n1 << @co_name
        n1 << " and supersedes any prior agreements, representations or understandings (whether written, oral or implied) between you and "
        n1 << @co_name
        n1 << ".  This letter agreement may not be amended or modified, except by an express written agreement signed by both you and a duly authorized officer of "
        n1 << @co_name
        n1 << ".  The terms of this letter agreement and the resolution of any disputes as to the meaning, effect, performance or validity of this letter agreement or arising out of, related to, or in any way connected with, this letter agreement, your employment with "
        n1 << @co_name
        n1 << " or any other relationship between you and "
        n1 << @co_name
        n1 << " (the “Disputes”) will be governed by State law, excluding laws relating to conflicts or choice of law.  You and "
        n1 << @co_name
        n1 << " submit to the exclusive personal jurisdiction of the federal and state courts in connection with any Dispute or any claim related to any Dispute."
        n1.line_break

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

      File.open('download.rtf', 'w') {|file| file.write(document.to_rtf)} # existing file by this name will be overwritten
      #send_file(File.join(DOWNLOAD_PATH, "create.rtf.rtf_rb"))
      send_file('download.rtf')
    else
      render action: 'new'
    end


  #  @letter = @wizard.object
  #  if @wizard.save
  #    redirect_to @letter, notice: "Letter saved!"
  #  else
  #    render :new
  #  end
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

  #  if @wizard.save
  #    redirect_to @letter, notice: 'Letter was successfully updated.'
  #  else
  #    render action: 'edit'
  #  end
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


=begin
  def load_letter
    @letter = Letter.find(params[:id])
  end

  def load_wizard
    @wizard = ModelWizard.new(@letter || Letter, session, params)
    if self.action_name.in? %w[new edit]
      @wizard.start
    elsif self.action_name.in? %w[create update]
      @wizard.process
    end
  end
=end

end
