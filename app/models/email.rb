class Email < ActiveRecord::Base
  validates :body, presence: true, email: true
end
