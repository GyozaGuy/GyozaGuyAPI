class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.timestamp :time
      t.text :content
      t.boolean :published
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :posts, :user_id
  end
end
