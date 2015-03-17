require 'htmltoword'

class LettersController < ApplicationController

  # On your controller.
  respond_to :docx

  # filename and word_template are optional. By default it will name the file as your action and use the default template provided by the gem. The use of the .docx in the filename and word_template is optional.
  def my_action
    # ...
    @letter = Letter.new
    respond_with(@object, filename: 'my_file.docx', word_template: 'my_template.docx')
    # Alternatively, if you don't want to create the .docx.erb template you could
    respond_with(@object, content: '<html><body>some html</body></html>', filename: 'my_file.docx')
  end

  def my_action2
    # ...
    respond_to do |format|
      format.docx do
        render docx: 'my_view', filename: 'my_file.docx'
        # Alternatively, if you don't want to create the .docx.erb template you could
        render docx: 'my_file.docx', content: '<html><body>some html</body></html>'
      end
    end
  end
end
