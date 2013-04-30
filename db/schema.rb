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

ActiveRecord::Schema.define(:version => 20130430160136) do

  create_table "challenges", :primary_key => "challenge_id", :force => true do |t|
    t.string   "title",       :limit => 200,        :null => false
    t.text     "description", :limit => 2147483647, :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "followers"
    t.string   "document"
    t.text     "lemma",       :limit => 2147483647
  end

  add_index "challenges", ["title"], :name => "title_UNIQUE", :unique => true

  create_table "collections", :primary_key => "collection_id", :force => true do |t|
    t.string "title",       :limit => 200
    t.text   "description", :limit => 2147483647, :null => false
    t.string "user",        :limit => 100,        :null => false
    t.string "document"
    t.text   "lemma"
  end

  create_table "comments", :primary_key => "comment_id", :force => true do |t|
    t.datetime "create_date"
    t.text     "description",  :limit => 2147483647, :null => false
    t.integer  "votes"
    t.string   "user",         :limit => 100,        :null => false
    t.string   "challenge",    :limit => 200
    t.string   "contribution", :limit => 200
    t.string   "document"
    t.text     "lemma",        :limit => 2147483647
  end

  create_table "contributions", :primary_key => "contribution_id", :force => true do |t|
    t.string   "title",       :limit => 200,        :null => false
    t.text     "description", :limit => 2147483647, :null => false
    t.datetime "create_date"
    t.integer  "views"
    t.integer  "votes"
    t.string   "challenge",   :limit => 200,        :null => false
    t.string   "user",        :limit => 100,        :null => false
    t.string   "document"
    t.text     "lemma",       :limit => 2147483647
  end

  create_table "document_term_matrices", :force => true do |t|
  end

  create_table "dummies", :primary_key => "dummy_id", :force => true do |t|
    t.string "title",       :limit => 200
    t.text   "description", :limit => 2147483647, :null => false
    t.string "user",        :limit => 100,        :null => false
    t.string "document"
    t.text   "lemma"
  end

  create_table "homes", :force => true do |t|
  end

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.string   "nick",       :limit => 50,         :null => false
    t.string   "name",       :limit => 100,        :null => false
    t.string   "motto",      :limit => 300
    t.text     "bio",        :limit => 2147483647
    t.datetime "join_date"
    t.string   "occupation", :limit => 100
    t.string   "company",    :limit => 100
    t.string   "country",    :limit => 100
  end

  add_index "users", ["name"], :name => "name_UNIQUE", :unique => true
  add_index "users", ["nick"], :name => "nick_UNIQUE", :unique => true

end
