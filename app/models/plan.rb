class Plan < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :price, presence: true
  validates :duration, presence: true
  validates :max_storage_space, presence: true
  validates :max_bandwidth_up, presence: true
  validates :max_bandwidth_down, presence: true
  validates :daily_shared_links_quota, presence: true
end
