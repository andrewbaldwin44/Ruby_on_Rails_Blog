class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.text :content

      t.timestamps
    end
  end
end
