ActiveAdmin.register User do
  permit_params :username, :email, :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip

  index do
    id_column
    column :username
    column :email
    column :sign_in_count
    column :last_sign_in_ip
    actions
  end
end
