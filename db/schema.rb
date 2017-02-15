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

ActiveRecord::Schema.define(version: 20160816015030) do

  create_table "articles", force: :cascade do |t|
    t.integer  "quantity",    limit: 4
    t.integer  "box_id",      limit: 4
    t.float    "unit_price",  limit: 24
    t.float    "total",       limit: 24
    t.integer  "order_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.float    "discount",    limit: 24
    t.integer  "price_id",    limit: 4
    t.integer  "total_boxes", limit: 4
    t.string   "package",     limit: 255
    t.string   "description", limit: 255
  end

  create_table "boxes", force: :cascade do |t|
    t.string   "description",             limit: 255
    t.float    "price",                   limit: 24
    t.integer  "capacity",                limit: 4
    t.float    "minimum_percentage_load", limit: 24
    t.boolean  "active"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "configs", force: :cascade do |t|
    t.string   "configuration_name",  limit: 255
    t.string   "configuration_value", limit: 255
    t.boolean  "active"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "configurations", force: :cascade do |t|
    t.string   "configuration_name",  limit: 255
    t.string   "configuration_value", limit: 255
    t.boolean  "active"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "box_id",      limit: 4
    t.datetime "update_date"
    t.integer  "quantity",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "price_id",    limit: 4
    t.integer  "total_boxes", limit: 4
    t.string   "package",     limit: 255
  end

  create_table "loads", force: :cascade do |t|
    t.text     "number",               limit: 65535
    t.float    "percentage_completed", limit: 24
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "status",               limit: 255
    t.datetime "sent_date"
    t.string   "order_number",         limit: 255
    t.string   "delivery_place",       limit: 255
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "load_id",             limit: 4
    t.string   "number",              limit: 255
    t.string   "customer_name",       limit: 255
    t.datetime "date"
    t.float    "percentage_complete", limit: 24
    t.float    "total",               limit: 24
    t.float    "subtotal",            limit: 24
    t.float    "taxes",               limit: 24
    t.integer  "status",              limit: 4
    t.integer  "order_type",          limit: 4
    t.boolean  "active"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "box_id",          limit: 4
    t.integer  "box_size_small",  limit: 4
    t.integer  "box_size_big",    limit: 4
    t.integer  "dozens_by_size",  limit: 4
    t.string   "price_by_dozen",  limit: 255
    t.string   "weight_by_dozen", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "rules", force: :cascade do |t|
    t.float    "percentage_load", limit: 24
    t.integer  "box_id",          limit: 4
    t.float    "max_discount",    limit: 24
    t.boolean  "active"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "quantity",    limit: 4
    t.integer  "article_id",  limit: 4
    t.datetime "date"
    t.boolean  "active"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "price_id",    limit: 4
    t.integer  "total_boxes", limit: 4
    t.string   "package",     limit: 255
  end

end
