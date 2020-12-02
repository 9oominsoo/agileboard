ActiveAdmin.register Project do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :start_at, :end_at, :image, :deleted_at, :project_status, user_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :text, :start_at, :end_at, :deleted_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :description do |project|
      project.description.truncate(20,omission: '...')
    end
    column :start_at
    column :end_at
    column :users do |project|
      project.users
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :start_at
      row :end_at
      row :project_status
      row :image do |project|
        image_tag(project.image.url, style: "width: 100px; height: 100px;")
      end
      row :users do |project|
        project.users
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :start_at
      f.input :end_at #if f.object.new_record?
      # f.input :project_status
      f.input :users, as: :check_boxes, multiple: true, collection: User.all.map{|u| ["#{u.name}, #{u.email}", u.id]}
      f.input :image, as: :file
      #f.input :emails, as: :select, collection: User.all.map{|u| u.id} 
    end
    f.actions
  end
end
