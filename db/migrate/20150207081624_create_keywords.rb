class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :phrase
      t.integer :ads_top_total
      t.integer :ads_bottom_total
      t.integer :ads_right_total
      t.integer :ads_total
      t.integer :search_on_page_total
      t.integer :total_links
      t.string :overall_total_search_res
      t.string :state, default: "new"

      t.timestamps
    end
  end
end
