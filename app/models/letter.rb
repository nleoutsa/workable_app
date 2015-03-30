class Letter < ActiveRecord::Base

  validates :co_name, :ap_name, :email, presence: true
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

end
