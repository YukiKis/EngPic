ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :name, :introduction, :image
  
  # :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, 
  actions :all, except: [:new, :create]
  
  menu parent: "管理項目", label: "ユーザー", priority: 1
  
  filter :id
  filter :name
  filter :email
  
  index do |u|
    column "ID", :id
    column "name", :name
    column "email", :email
    actions defaults: false do |user|
      item "View", admin_user_path(user)
    end
  end
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :email
      f.input :introduction
      f.attachment_field :image
    end
    f.actions
  end
  
  show do |u|
    attributes_table do
      row :name
      row :email
      row :introduction
      row :words
      row :image do
        attachment_image_tag(u, :image, :fill, 50, 50, fallback: "noimage.jpg", size: "50x50")
      end
    end
    active_admin_comments
  end

  
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :introduction, :image_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
