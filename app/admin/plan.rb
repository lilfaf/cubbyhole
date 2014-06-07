ActiveAdmin.register Plan do
  permit_params :name, :price, :max_storage_space, :max_bandwidth_up, :max_bandwidth_down, :daily_shared_links_quota
end
