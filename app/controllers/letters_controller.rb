
class LettersController < ApplicationController

  before_action :load_letter, only: [:show, :update, :edit, :destroy]
  before_action :load_wizard, only: [:new, :edit, :create, :update]

  require 'rtf'
  include RTF
  respond_to :rtf

  def index
    @letters = Letter.all
  end

  def show
  end


  def new
    @letter = @wizard.object
  end

  def create
    @letter = @wizard.object
    if @wizard.save
      redirect_to @letter, notice: "Letter saved!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @wizard.save
      redirect_to @letter, notice: 'Letter was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    redirect_to root_path
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
        n1 << "cool!                       "
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


  private

  def letter_params
    params.require(:letter).permit(:id, :co_name, :co_address_1, :co_address_2, :pos_title)
  end


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


end
