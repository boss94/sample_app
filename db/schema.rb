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

ActiveRecord::Schema.define(:version => 20130506093431) do

  create_table "images", :force => true do |t|
    t.string  "url"
    t.string  "name"
    t.string  "view"
    t.integer "vehicle_id"
  end

  add_index "images", ["vehicle_id"], :name => "index_images_on_vehicle_id"

  create_table "makes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.integer  "make_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "models", ["make_id"], :name => "index_models_on_make_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "content_typetext"
    t.text     "content_fulltext"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "role"
    t.string   "email_group"
    t.text     "address"
    t.string   "country"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vehicles", :force => true do |t|
    t.integer  "model_id"
    t.string   "additional_details"
    t.string   "registration"
    t.integer  "registration_year"
    t.string   "fuel"
    t.integer  "mileage"
    t.boolean  "mileage_warranty"
    t.float    "price"
    t.string   "color"
    t.string   "doors"
    t.string   "body_type"
    t.text     "equipment"
    t.text     "notes"
    t.string   "equipment_typetext"
    t.text     "equipment_fulltext"
    t.string   "notes_typetext"
    t.text     "notes_fulltext"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "vehicles", ["model_id"], :name => "index_vehicles_on_model_id"

end
