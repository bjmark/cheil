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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111021104449) do

  create_table "admin_users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brief_comments", :force => true do |t|
    t.string   "content"
    t.integer  "brief_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brief_vendors", :force => true do |t|
    t.integer  "brief_id"
    t.integer  "org_id"
    t.string   "approved",   :limit => 1, :default => "n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "briefs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "org_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "send_to_cheil", :limit => 1, :default => "n"
  end

  create_table "items", :force => true do |t|
    t.integer  "brief_id"
    t.string   "name"
    t.string   "quantity"
    t.string   "price"
    t.string   "kind"
    t.integer  "parent_id",                    :default => 0
    t.integer  "brief_vendor_id"
    t.string   "checked",         :limit => 1, :default => "n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orgs", :force => true do |t|
    t.string   "name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.string   "phone"
    t.integer  "org_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
