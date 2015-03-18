require 'htmltoword'

class LettersController < ApplicationController

  # On your controller.
  respond_to :docx

  # filename and word_template are optional. By default it will name the file as your action and use the default template provided by the gem. The use of the .docx in the filename and word_template is optional.
  def create
    # ...
    @letter = Letter.new
    # respond_with(@letter, filename: 'my_file.docx', word_template: 'my_template.docx')
    # Alternatively, if you don't want to create the .docx.erb template you could
    respond_with(@letter, content: '<html><body>some html</body></html>', filename: 'nmml_file.docx')
  end

end
