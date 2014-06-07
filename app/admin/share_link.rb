ActiveAdmin.register ShareLink do
  permit_params :token, :expires_at, :created_at, :updated_at
end
