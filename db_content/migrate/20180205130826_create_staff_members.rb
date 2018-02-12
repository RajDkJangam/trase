class CreateStaffMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :staff_members do |t|
      t.text :name, null: false
      t.integer :position, null: false
      t.text :bio, null: false
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end