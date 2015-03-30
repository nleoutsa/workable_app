class EmailapiController < ApplicationController
  def subscribe
    @list_id = ENV["MAILCHIMP_LIST_ID"]
    gb = Gibbon::API.new

    gb.lists.subscribe({
      :id => @list_id,
      :email => {:email => params[:letter][:email]}
      })
  end
end
