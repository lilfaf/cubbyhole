class Plan < ActiveRecord::Base
	has_many :users
	
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :max_storage_space, presence: true
  validates :max_bandwidth_up, presence: true
  validates :max_bandwidth_down, presence: true
  validates :daily_shared_links_quota, presence: true
end
