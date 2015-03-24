class Letter < ActiveRecord::Base

  include ActiveModel::Model
  attr_accessor :ap_email, :string
  validates_presence_of :ap_email
  validates_format_of :co_email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  validates :co_name, :ap_name, presence: true


  def subscribe
    mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
    result = mailchimp.lists.subscribe({
      :id => Rails.application.secrets.mailchimp_list_id,
      :email => {:email => self.ap_email},
      :double_optin => false,
      :update_existing => true,
      :send_welcome => true
    })
    Rails.logger.info("Subscribed #{self.ap_email} to MailChimp") if result
  end

 # validates :name, presence: true, if: :step1?
 # validates :quantity, numericality: true, if: :step2?
 # validates :tags, presence: true, if: :step3?

 # include MultiStepModel

 # def self.total_steps
 #   5
 # end
end
