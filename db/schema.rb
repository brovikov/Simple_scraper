# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150207091226) do

  create_table "keywords", force: true do |t|
    t.string   "phrase"
    t.integer  "ads_top_total"
    t.integer  "ads_bottom_total"
    t.integer  "ads_right_total"
    t.integer  "ads_total"
    t.integer  "search_on_page_total"
    t.integer  "total_links"
    t.string   "overall_total_search_res"
    t.string   "state",                    default: "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.string   "url"
    t.string   "type"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
