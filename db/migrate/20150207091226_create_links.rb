class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :type
      t.integer :keyword_id

      t.timestamps
    end
  end
end
