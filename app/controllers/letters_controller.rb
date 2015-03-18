
class LettersController < ApplicationController
  require 'rtf'
  include RTF

  respond_to :html, :rtf

  def export

  end



end
