
class LettersController < ApplicationController

  require 'rtf'
  include RTF
  respond_to :rtf

#  DOWNLOAD_PATH = File.join(Rails.root, "app", "views", "letters")

  def index
    @letters = Letter.all
  end

  def show
    @letter = Letter.find(params[:id])
  end

  def new
    @letter = Letter.new
  end




  def create
    @letter = Letter.new(letter_params)

    if @letter.save

## subscribe email address to mailing list:
      @list_id = ENV["MAILCHIMP_LIST_ID"]
      gb = Gibbon::API.new(["MAILCHIMP_API_KEY"])

      gb.lists.subscribe({
        :id => @list_id,
        :email => {:email => params[:letter][:email]}
        })


      redirect_to new_letter_path

  ############################################################
  #                                                          #
  #              FORMATTING FOR .rtf download                #
  #                                                          #
  ############################################################
      document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))


      @co_name = (params[:letter][:co_name].length > 0) ? params[:letter][:co_name] : "______________________"
      @co_address_1 = (params[:letter][:co_address_1].length > 0) ? params[:letter][:co_address_1] : "______________________"
      @co_address_2 = params[:letter][:co_address_2]
      @co_city_state_zip = (params[:letter][:co_city_state_zip].length > 0) ? params[:letter][:co_city_state_zip] : "______________________"

      @ap_name = (params[:letter][:ap_name].length > 0) ? params[:letter][:ap_name] : "______________________"
      @ap_address_1 = (params[:letter][:ap_address_1].length > 0) ? params[:letter][:ap_address_1] : "______________________"
      @ap_address_2 = params[:letter][:ap_address_2]
      @ap_city_state_zip = (params[:letter][:ap_city_state_zip].length > 0) ? params[:letter][:ap_city_state_zip] : "______________________"

      @pos_title = (params[:letter][:pos_title].length > 0) ? params[:letter][:pos_title] : "______________________"
      @supervisor = (params[:letter][:supervisor].length > 0) ? params[:letter][:supervisor] : "______________________"
      @start_date = (params[:letter][:start_date].length > 0) ? params[:letter][:start_date] : "______________________"
      @expiry_date = (params[:letter][:expiry_date].length > 0) ? params[:letter][:expiry_date] : "______________________"
      @hrs = (params[:letter][:hrs].length > 0) ? params[:letter][:hrs] : "______________________"

      @co_rep = (params[:letter][:co_rep].length > 0) ? params[:letter][:co_rep] : "______________________"

      @ap_wage = (params[:letter][:ap_wage].length > 0) ? params[:letter][:ap_wage] : "______________________"

      @dental = params[:dental]
      @medical = params[:medical]
      @equity = params[:equity]
      @commission = params[:commission]
      @bonus = params[:bonus]

      @drug_test = params[:drug_test]
      @bg_check = params[:bg_check]

    # set styles for different sections of .rtf file...
      styles = {}
      styles['Para_Style'] = ParagraphStyle.new
      styles['BOLD'] = CharacterStyle.new
      styles['Justify'] = ParagraphStyle.new
      styles['Right_Align'] = ParagraphStyle.new

      styles['Para_Style'].left_indent = 0
      styles['Right_Align'].justification = ParagraphStyle::RIGHT_JUSTIFY
      styles['Justify'].justification = ParagraphStyle::LEFT_JUSTIFY
      styles['Justify'].left_indent = 0
    #  styles['Char_Style'].font        = Font.new(Font::MODERN, 'Courier')
      styles['BOLD'].bold        = true

      document.paragraph(styles['Right_Align']) do |n1|
        n1 << @co_name
        n1.line_break
        n1 << @co_address_1
        n1.line_break if @co_address_2.length > 0
        n1 << @co_address_2 if @co_address_2.length > 0
        n1.line_break
        n1 << @co_city_state_zip
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Para_Style']) do |n1|
        n1 << @ap_name
        n1.line_break
        n1 << @ap_address_1
        n1.line_break if @ap_address_2.length > 0
        n1 << @ap_address_2 if @ap_address_2.length > 0
        n1.line_break
        n1 << @ap_city_state_zip
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|

        n1 << "Dear "
        n1 << @ap_name
        n1 << ","
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
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Hours and Compensation"
        end
        n1 << "This is a full-time, exempt position requiring approximately "
        n1 << @hrs
        n1 << " hours per week. "
        n1.line_break
        n1.line_break
        n1 << "Your compensation package includes base pay and the following:"
        n1.line_break
        n1 << "- Standard benefits package."
        n1.line_break
        n1 << "- Eligibility to enroll in medical insurance through the company's provider." if @medical == "1"
        n1.line_break if @medical == "1"
        n1 << "- Eligibility to enroll in dental insurance through the company's provider." if @dental == "1"
        n1.line_break if @dental == "1"
        n1 << "- Equity in the company. Details provided on a separate document." if @equity == "1"
        n1.line_break if @equity == "1"
        n1 << "- Eligibility for a performance-based bonus to be outlined in a separate document." if @bonus == "1"
        n1.line_break if @bonus == "1"
        n1 << "- A commission structure which will be outlined in a separate document." if @commission == "1"
        n1.line_break if @commission == "1"
        n1.line_break
        n1 << "You base pay is $"
        n1 << @ap_wage
        n1 << ". Standard tax deductions will be made pursuant to state and federal law."
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Termination"
        end
        n1.line_break
        n1 << "You are entering into an agreement of at-will employment. "
        n1 << @co_name
        n1 << " may terminate employment at any time without notice or cause, but will make every effort to provide timely notice."
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Tax Matters"
        end
        n1.line_break
        n1 << "(a) "
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Withholding. "
        end
        n1 << "All forms of compensation referred to in this letter agreement are subject to reduction to reflect applicable withholding and payroll taxes and other deductions required by law."
        n1.line_break
        n1 << "(b) "
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Tax Advice. "
        end
        n1 << "You are encouraged to obtain your own tax advice regarding your compensation from "
        n1 << @co_name
        n1 << ". You agree that "
        n1 << @co_name
        n1 << " does not have a duty to design its compensation policies in a manner that minimizes your tax liabilities, and you will not make any claim against "
        n1 << @co_name
        n1 << " or its Board of Directors related to tax liabilities arising from your compensation."

        n1.line_break
        n1.line_break
        n1.line_break
      end


      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Conditions for Employment"
        end
        n1.line_break
        n1 << "This offer is contingent upon the following:"
        n1.line_break
        n1 << "- Proof of eligibility to work in the United States (which must be provided per the terms of the Immigration and Reform Act)."
        n1.line_break
        n1 << "- Completion of a drug test." if @drug_test == "1"
        n1.line_break if @drug_test == "1"
        n1 << "- Completion of a background check." if @bg_check == "1"
        n1.line_break if @bg_check == "1"
        n1 << "- You will be required to submit the proper paperwork to confirm your eligibility and tax status. This includes I-9 and W-4 forms, which will be provided."
        n1.line_break
        n1.line_break
        n1.line_break
        n1 << "You may indicate your agreement with these terms and accept this offer by signing and dating this agreement by "
        n1 << @expiry_date
        n1 << ". Upon your acceptance of this employment offer, "
        n1 << @co_name
        n1 << " will provide you with the necessary paperwork and instructions."
        n1.line_break
        n1.line_break
        n1.line_break
      end


      document.paragraph(styles['Justify']) do |n1|
        n1 << "We look forward to hearing from you."
        n1.line_break
        n1.line_break
        n1 << "Sincerely,"
        n1.line_break
        n1.line_break
        n1 << @co_rep
        n1.line_break
        n1.line_break
        n1 << "Signatures:"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Company Representative (Sign)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Company Representative (Print)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Date"
        n1.line_break
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Applicant (Sign)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Applicant (Print)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Date"
        n1.line_break

      end


      File.open('offer_letter.rtf', 'w') {|file| file.write(document.to_rtf)}
      send_file('offer_letter.rtf')



  ############################################################
  #                                                          #
  #              FORMATTING FOR .rtf download                #
  #                                                          #
  ############################################################

    #  else
    #    render action: 'new'
    end


  end






































#############################
# Only using new and create #
#############################


  def edit
    @letter = Letter.find(params[:id])
  end

  def update
    @letter = Letter.find(params[:id])
    if @letter.update_attributes(letter_params)



## subscribe email to mailing list:

      @list_id = ENV["MAILCHIMP_LIST_ID"]
      gb = Gibbon::API.new

      gb.lists.subscribe({
        :id => @list_id,
        :email => {:email => params[:letter][:email]}
        })


      redirect_to @letter
  ############################################################
  #                                                          #
  #              FORMATTING FOR .rtf download                #
  #                                                          #
  ############################################################
      document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))


      @co_name = (params[:letter][:co_name].length > 0) ? params[:letter][:co_name] : "______________________"
      @co_address_1 = (params[:letter][:co_address_1].length > 0) ? params[:letter][:co_address_1] : "______________________"
      @co_address_2 = params[:letter][:co_address_2]
      @co_city_state_zip = (params[:letter][:co_city_state_zip].length > 0) ? params[:letter][:co_city_state_zip] : "______________________"

      @ap_name = (params[:letter][:ap_name].length > 0) ? params[:letter][:ap_name] : "______________________"
      @ap_address_1 = (params[:letter][:ap_address_1].length > 0) ? params[:letter][:ap_address_1] : "______________________"
      @ap_address_2 = params[:letter][:ap_address_2]
      @ap_city_state_zip = (params[:letter][:ap_city_state_zip].length > 0) ? params[:letter][:ap_city_state_zip] : "______________________"

      @pos_title = (params[:letter][:pos_title].length > 0) ? params[:letter][:pos_title] : "______________________"
      @supervisor = (params[:letter][:supervisor].length > 0) ? params[:letter][:supervisor] : "______________________"
      @start_date = (params[:letter][:start_date].length > 0) ? params[:letter][:start_date] : "______________________"
      @expiry_date = (params[:letter][:expiry_date].length > 0) ? params[:letter][:expiry_date] : "______________________"
      @hrs = (params[:letter][:hrs].length > 0) ? params[:letter][:hrs] : "______________________"

      @co_rep = (params[:letter][:co_rep].length > 0) ? params[:letter][:co_rep] : "______________________"

      @ap_wage = (params[:letter][:ap_wage].length > 0) ? params[:letter][:ap_wage] : "______________________"

      @dental = params[:dental]
      @medical = params[:medical]
      @equity = params[:equity]
      @commission = params[:commission]
      @bonus = params[:bonus]

      @drug_test = params[:drug_test]
      @bg_check = params[:bg_check]

    # set styles for different sections of .rtf file...
      styles = {}
      styles['Para_Style'] = ParagraphStyle.new
      styles['BOLD'] = CharacterStyle.new
      styles['Justify'] = ParagraphStyle.new
      styles['Right_Align'] = ParagraphStyle.new

      styles['Para_Style'].left_indent = 0
      styles['Right_Align'].justification = ParagraphStyle::RIGHT_JUSTIFY
      styles['Justify'].justification = ParagraphStyle::LEFT_JUSTIFY
      styles['Justify'].left_indent = 0
    #  styles['Char_Style'].font        = Font.new(Font::MODERN, 'Courier')
      styles['BOLD'].bold        = true

      document.paragraph(styles['Right_Align']) do |n1|
        n1 << @co_name
        n1.line_break
        n1 << @co_address_1
        n1.line_break if @co_address_2.length > 0
        n1 << @co_address_2 if @co_address_2.length > 0
        n1.line_break
        n1 << @co_city_state_zip
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Para_Style']) do |n1|
        n1 << @ap_name
        n1.line_break
        n1 << @ap_address_1
        n1.line_break if @ap_address_2.length > 0
        n1 << @ap_address_2 if @ap_address_2.length > 0
        n1.line_break
        n1 << @ap_city_state_zip
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|

        n1 << "Dear "
        n1 << @ap_name
        n1 << ","
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
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Hours and Compensation"
        end
        n1 << "This is a full-time, exempt position requiring approximately "
        n1 << @hrs
        n1 << " hours per week. "
        n1.line_break
        n1.line_break
        n1 << "Your compensation package includes base pay and the following:"
        n1.line_break
        n1 << "- Standard benefits package."
        n1.line_break
        n1 << "- Eligibility to enroll in medical insurance through the company's provider." if @medical == "1"
        n1.line_break if @medical == "1"
        n1 << "- Eligibility to enroll in dental insurance through the company's provider." if @dental == "1"
        n1.line_break if @dental == "1"
        n1 << "- Equity in the company. Details provided on a separate document." if @equity == "1"
        n1.line_break if @equity == "1"
        n1 << "- Eligibility for a performance-based bonus to be outlined in a separate document." if @bonus == "1"
        n1.line_break if @bonus == "1"
        n1 << "- A commission structure which will be outlined in a separate document." if @commission == "1"
        n1.line_break if @commission == "1"
        n1.line_break
        n1 << "You base pay is $"
        n1 << @ap_wage
        n1 << ". Standard tax deductions will be made pursuant to state and federal law."
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Termination"
        end
        n1.line_break
        n1 << "You are entering into an agreement of at-will employment. "
        n1 << @co_name
        n1 << " may terminate employment at any time without notice or cause, but will make every effort to provide timely notice."
        n1.line_break
        n1.line_break
        n1.line_break
      end

      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Tax Matters"
        end
        n1.line_break
        n1 << "(a) "
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Withholding. "
        end
        n1 << "All forms of compensation referred to in this letter agreement are subject to reduction to reflect applicable withholding and payroll taxes and other deductions required by law."
        n1.line_break
        n1 << "(b) "
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Tax Advice. "
        end
        n1 << "You are encouraged to obtain your own tax advice regarding your compensation from "
        n1 << @co_name
        n1 << ". You agree that "
        n1 << @co_name
        n1 << " does not have a duty to design its compensation policies in a manner that minimizes your tax liabilities, and you will not make any claim against "
        n1 << @co_name
        n1 << " or its Board of Directors related to tax liabilities arising from your compensation."

        n1.line_break
        n1.line_break
        n1.line_break
      end


      document.paragraph(styles['Justify']) do |n1|
        n1.apply(styles['BOLD']) do |n2|
           n2 << "Conditions for Employment"
        end
        n1.line_break
        n1 << "This offer is contingent upon the following:"
        n1.line_break
        n1 << "- Proof of eligibility to work in the United States (which must be provided per the terms of the Immigration and Reform Act)."
        n1.line_break
        n1 << "- Completion of a drug test." if @drug_test == "1"
        n1.line_break if @drug_test == "1"
        n1 << "- Completion of a background check." if @bg_check == "1"
        n1.line_break if @bg_check == "1"
        n1 << "- You will be required to submit the proper paperwork to confirm your eligibility and tax status. This includes I-9 and W-4 forms, which will be provided."
        n1.line_break
        n1.line_break
        n1 << "You may indicate your agreement with these terms and accept this offer by signing and dating this agreement by "
        n1 << @expiry_date
        n1 << ". Upon your acceptance of this employment offer, "
        n1 << @co_name
        n1 << " will provide you with the necessary paperwork and instructions."
        n1.line_break
        n1.line_break
        n1.line_break
      end


      document.paragraph(styles['Justify']) do |n1|
        n1 << "We look forward to hearing from you."
        n1.line_break
        n1.line_break
        n1 << "Sincerely,"
        n1.line_break
        n1.line_break
        n1 << @co_rep
        n1.line_break
        n1.line_break
        n1 << "Signatures:"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Company Representative (Sign)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Company Representative (Print)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Date"
        n1.line_break
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Applicant (Sign)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Applicant (Print)"
        n1.line_break
        n1.line_break
        n1 << "___________________________________________________"
        n1.line_break
        n1 << "Date"
        n1.line_break

      end


      File.open('offer_letter.rtf', 'w') {|file| file.write(document.to_rtf)}
      send_file('offer_letter.rtf')


  ############################################################
  #                                                          #
  #              FORMATTING FOR .rtf download                #
  #                                                          #
  ############################################################



    else
      render action: 'edit'
    end

  end

  def destroy
    @letter = Letter.find(params[:id])
  end



  private

  def letter_params
    params.require(:letter).permit(:id, :co_name, :co_address_1, :co_address_2, :co_city_state_zip, :ap_name, :ap_address_1, :ap_address_2, :ap_city_state_zip, :pos_title, :supervisor, :start_date, :expiry_date, :email, :ap_wage, :co_rep, :dental, :medical, :bonus, :commission, :equity, :bg_check, :drug_test, :hrs)
  end


end
