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

ActiveRecord::Schema.define(:version => 20120227082525) do

  create_table "admin_users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attaches", :force => true do |t|
    t.string   "type"
    t.integer  "fk_id"
    t.integer  "user_id"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "checked",             :limit => 1, :default => "n"
    t.string   "read_by"
    t.string   "self_right"
    t.string   "notice"
  end

  add_index "attaches", ["fk_id"], :name => "index_attaches_on_fk_id"

  create_table "brief_attaches", :force => true do |t|
    t.integer  "brief_id"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
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
    t.integer  "rpm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cheil_id",                           :default => 0
    t.text     "req"
    t.date     "deadline"
    t.string   "read_by"
    t.integer  "status"
    t.string   "cancel",                :limit => 1, :default => "n"
    t.string   "self_right"
    t.string   "attach_right"
    t.string   "item_right"
    t.string   "comment_right"
    t.string   "vendor_solution_right"
    t.string   "notice"
    t.string   "cheil_solution_right"
    t.datetime "status_10"
    t.datetime "status_20"
    t.datetime "status_30"
    t.datetime "status_40"
    t.datetime "status_50"
    t.datetime "status_60"
  end

  add_index "briefs", ["cheil_id"], :name => "index_briefs_on_cheil_id"
  add_index "briefs", ["rpm_id"], :name => "index_briefs_on_rpm_id"

  create_table "comments", :force => true do |t|
    t.string   "type"
    t.integer  "fk_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.string   "self_right"
    t.string   "notice"
  end

  add_index "comments", ["fk_id"], :name => "index_comments_on_fk_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "quantity"
    t.string   "price"
    t.string   "kind"
    t.integer  "parent_id",                 :default => 0
    t.string   "checked",      :limit => 1, :default => "n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "fk_id"
    t.string   "note"
    t.string   "read_by"
    t.string   "self_right"
    t.string   "notice"
    t.string   "tax_rate"
    t.string   "tax"
    t.string   "total_up"
    t.string   "total_up_tax"
    t.integer  "score"
  end

  add_index "items", ["fk_id"], :name => "index_items_on_fk_id"

  create_table "logins", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.datetime "login_time"
    t.datetime "logout_time"
    t.string   "is_logout",   :limit => 1, :default => "n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orgs", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rpm_org_id"
    t.integer  "brief_count", :default => 0
    t.integer  "money_sum",   :default => 0
  end

  create_table "payers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "solution_id"
    t.integer  "payer_id"
    t.integer  "org_id"
    t.string   "amount"
    t.date     "pay_date"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["solution_id"], :name => "index_payments_on_solution_id"

  create_table "solutions", :force => true do |t|
    t.integer  "brief_id"
    t.integer  "org_id"
    t.string   "type"
    t.string   "is_sent"
    t.datetime "sent_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "design_rate",                        :default => "0"
    t.string   "product_rate",                       :default => "0"
    t.string   "tran_rate",                          :default => "0"
    t.string   "other_rate",                         :default => "0"
    t.string   "is_approved",           :limit => 1, :default => "n"
    t.datetime "approved_at"
    t.string   "read_by"
    t.datetime "finish_at"
    t.string   "self_right"
    t.string   "attach_right"
    t.string   "item_right"
    t.string   "comment_right"
    t.string   "notice"
    t.integer  "design_sum",                         :default => 0
    t.integer  "product_sum",                        :default => 0
    t.integer  "tran_sum",                           :default => 0
    t.integer  "other_sum",                          :default => 0
    t.integer  "design_tax_sum",                     :default => 0
    t.integer  "product_tax_sum",                    :default => 0
    t.integer  "tran_tax_sum",                       :default => 0
    t.integer  "other_tax_sum",                      :default => 0
    t.integer  "design_and_tax_sum",                 :default => 0
    t.integer  "product_and_tax_sum",                :default => 0
    t.integer  "tran_and_tax_sum",                   :default => 0
    t.integer  "other_and_tax_sum",                  :default => 0
    t.integer  "all_sum",                            :default => 0
    t.integer  "all_tax_sum",                        :default => 0
    t.integer  "all_and_tax_sum",                    :default => 0
    t.integer  "design_c_sum",                       :default => 0
    t.integer  "product_c_sum",                      :default => 0
    t.integer  "tran_c_sum",                         :default => 0
    t.integer  "other_c_sum",                        :default => 0
    t.integer  "design_c_tax_sum",                   :default => 0
    t.integer  "product_c_tax_sum",                  :default => 0
    t.integer  "tran_c_tax_sum",                     :default => 0
    t.integer  "other_c_tax_sum",                    :default => 0
    t.integer  "design_c_and_tax_sum",               :default => 0
    t.integer  "product_c_and_tax_sum",              :default => 0
    t.integer  "tran_c_and_tax_sum",                 :default => 0
    t.integer  "other_c_and_tax_sum",                :default => 0
    t.integer  "all_c_sum",                          :default => 0
    t.integer  "all_c_tax_sum",                      :default => 0
    t.integer  "all_c_and_tax_sum",                  :default => 0
    t.integer  "payment_sum",                        :default => 0
    t.integer  "balance",                            :default => 0
  end

  add_index "solutions", ["brief_id"], :name => "index_solutions_on_brief_id"
  add_index "solutions", ["org_id"], :name => "index_solutions_on_org_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.string   "phone"
    t.integer  "org_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

end
