ActiveAdmin.register Website do
  index do
    column :name
    column :url
    column :status_code
    column :status_message
    column :checked_at
    default_actions
  end

  filter :name
  filter :url
  filter :status_code

  form do |f|
    f.inputs "Website Details" do
      f.input :name
      f.input :url
    end
    f.actions
  end
end
