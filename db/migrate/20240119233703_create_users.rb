class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :bigint do |t|
      t.string :username
      t.string :email
      t.text :profilePicture

      t.timestamps
    end
  end
end
