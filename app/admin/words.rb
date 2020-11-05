ActiveAdmin.register Word do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :name, :meaning, :sentence, :image_id, :tag_list
  
  menu parent: ["管理項目"], label: "単語", priority: 1
  
  actions :all, except: [:new, :create]
  
  filter :user_id, label: "USER ID"
  filter :name_or_meaning_start, as: :string, label: "Name or Meaning"
  filter :tags
  
  config.per_page = 15
  
  index do
    selectable_column
    column :name
    column :meaning
    column :created_at
    actions defaults: false do |word|
      item "View", admin_word_path(word)
    end
    column :user
  end
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :meaning
      f.input :sentence
    end
    f.actions
  end
  
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :name, :meaning, :sentence, :image_id, :tag_list]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
