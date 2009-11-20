# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091115040617) do

  create_table "age_range_versions", :force => true do |t|
    t.integer  "age_range_id"
    t.integer  "version"
    t.integer  "quote_id",     :limit => 8
    t.integer  "age_from",     :limit => 8
    t.integer  "age_to",       :limit => 8
    t.integer  "femenine",     :limit => 8
    t.integer  "masculine",    :limit => 8
    t.datetime "updated_at"
    t.boolean  "from_web"
  end

  create_table "age_ranges", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "age_from"
    t.integer  "age_to"
    t.integer  "femenine"
    t.integer  "masculine"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.boolean  "from_web"
  end

  add_index "age_ranges", ["quote_id"], :name => "index_age_ranges_on_quote_id"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brands", ["name"], :name => "index_brands_on_name"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "category_id", :limit => 8
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_id"], :name => "index_categories_on_category_id"
  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.string   "dni"
    t.string   "ruc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "legal_representative"
    t.string   "contact_person"
    t.string   "contact_email"
    t.decimal  "budget",               :precision => 10, :scale => 2
    t.integer  "child_number"
    t.boolean  "delta",                                               :default => false
    t.string   "client_type"
  end

  create_table "exit_order_details", :force => true do |t|
    t.integer  "exit_order_id"
    t.integer  "product_id"
    t.decimal  "price",         :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "discount"
    t.decimal  "quantity",      :precision => 10, :scale => 2
  end

  add_index "exit_order_details", ["exit_order_id"], :name => "index_exit_order_details_on_exit_order_id"
  add_index "exit_order_details", ["product_id"], :name => "index_exit_order_details_on_product_id"

  create_table "exit_orders", :force => true do |t|
    t.integer  "store_id"
    t.integer  "client_id"
    t.datetime "sending_date"
    t.string   "driver_name"
    t.string   "driver_dni"
    t.text     "extra_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "document"
    t.boolean  "unload_stock"
    t.string   "address"
    t.decimal  "price",                    :precision => 10, :scale => 2
    t.integer  "exit_order_details_count",                                :default => 0
  end

  add_index "exit_orders", ["client_id"], :name => "index_exit_orders_on_client_id"
  add_index "exit_orders", ["status", "store_id"], :name => "index_exit_orders_on_status_and_store_id"
  add_index "exit_orders", ["store_id"], :name => "index_exit_orders_on_store_id"

  create_table "expenses", :force => true do |t|
    t.decimal  "amount",       :precision => 10, :scale => 2
    t.string   "description"
    t.datetime "expense_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
  end

  create_table "fast_sessions", :force => true do |t|
    t.integer   "session_id_crc",               :null => false
    t.string    "session_id",     :limit => 32, :null => false
    t.timestamp "updated_at",                   :null => false
    t.text      "data"
  end

  add_index "fast_sessions", ["session_id_crc", "session_id"], :name => "session_id", :unique => true
  add_index "fast_sessions", ["updated_at"], :name => "updated_at"

  create_table "funds", :force => true do |t|
    t.integer  "store_id"
    t.datetime "registry_date"
    t.decimal  "net_income",     :precision => 10, :scale => 2
    t.decimal  "decimal",        :precision => 10, :scale => 2
    t.decimal  "widthdrawal",    :precision => 10, :scale => 2
    t.decimal  "cash_amount",    :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "expenses",       :precision => 10, :scale => 2
    t.decimal  "earnings",       :precision => 10, :scale => 2
    t.integer  "yesterday_fund"
  end

  add_index "funds", ["store_id"], :name => "index_funds_on_store_id"

  create_table "input_order_details", :force => true do |t|
    t.decimal  "quantity",                     :precision => 10, :scale => 2
    t.decimal  "cost",                         :precision => 10, :scale => 2
    t.integer  "product_id",      :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "input_order_id",  :limit => 8
    t.string   "additional_code"
    t.integer  "prices_count",                                                :default => 0
  end

  add_index "input_order_details", ["input_order_id"], :name => "input_order_id"
  add_index "input_order_details", ["product_id"], :name => "product_id"

  create_table "input_orders", :force => true do |t|
    t.integer  "provider_id",               :limit => 8
    t.decimal  "cost",                                   :precision => 10, :scale => 2
    t.datetime "order_date"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id",                  :limit => 8
    t.integer  "owner_id",                  :limit => 8
    t.date     "buying_date"
    t.string   "code"
    t.string   "status"
    t.string   "document"
    t.boolean  "unload_stock"
    t.string   "input_type"
    t.integer  "input_order_details_count",                                             :default => 0
  end

  add_index "input_orders", ["owner_id"], :name => "index_input_orders_on_owner_id"
  add_index "input_orders", ["provider_id"], :name => "index_input_orders_on_provider_id"
  add_index "input_orders", ["store_id"], :name => "index_input_orders_on_store_id"

  create_table "options", :force => true do |t|
    t.integer  "current_store"
    t.float    "igv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_details", :force => true do |t|
    t.integer  "product_id",              :limit => 8
    t.integer  "order_id",                :limit => 8
    t.decimal  "price",                                :precision => 10, :scale => 2
    t.decimal  "quantity",                             :precision => 10, :scale => 2
    t.integer  "discount",                :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sending_guide_detail_id"
    t.integer  "pending"
  end

  add_index "order_details", ["order_id"], :name => "order_id"
  add_index "order_details", ["product_id"], :name => "product_id"
  add_index "order_details", ["sending_guide_detail_id"], :name => "sending_guide_detail_id"

  create_table "orders", :force => true do |t|
    t.integer  "store_id",            :limit => 8
    t.datetime "order_date"
    t.integer  "client_id",           :limit => 8
    t.string   "address"
    t.decimal  "price",                            :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "number",              :limit => 8
    t.string   "status"
    t.string   "credit_card"
    t.integer  "sending_guide_id"
    t.boolean  "unload_stock"
    t.integer  "quote_id"
    t.boolean  "orders_generated"
    t.integer  "order_details_count",                                             :default => 0
  end

  add_index "orders", ["client_id"], :name => "index_orders_on_client_id"
  add_index "orders", ["quote_id"], :name => "index_orders_on_quote_id"
  add_index "orders", ["sending_guide_id"], :name => "index_orders_on_sending_guide_id"
  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "order",      :limit => 8
    t.integer  "parent_id",  :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "prices", :force => true do |t|
    t.decimal  "amount",                             :precision => 10, :scale => 2
    t.text     "description"
    t.integer  "discount",              :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id",            :limit => 8
    t.integer  "input_order_detail_id", :limit => 8
  end

  add_index "prices", ["input_order_detail_id"], :name => "input_order_detail_id"
  add_index "prices", ["product_id"], :name => "product_id"

  create_table "product_logs", :force => true do |t|
    t.integer  "product_logs_id"
    t.integer  "product_id"
    t.string   "controller"
    t.string   "method"
    t.decimal  "last_stock",         :precision => 10, :scale => 2
    t.decimal  "last_stock_trigal",  :precision => 10, :scale => 2
    t.decimal  "last_stock_polo",    :precision => 10, :scale => 2
    t.decimal  "last_stock_almacen", :precision => 10, :scale => 2
    t.decimal  "last_stock_clarisa", :precision => 10, :scale => 2
    t.decimal  "stock",              :precision => 10, :scale => 2
    t.decimal  "stock_trigal",       :precision => 10, :scale => 2
    t.decimal  "stock_polo",         :precision => 10, :scale => 2
    t.decimal  "stock_almacen",      :precision => 10, :scale => 2
    t.decimal  "stock_clarisa",      :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "additional_code"
    t.string   "name"
    t.string   "description"
    t.decimal  "stock",                                  :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "code"
    t.string   "picture"
    t.integer  "picture_filesize",          :limit => 8
    t.boolean  "visible"
    t.string   "barcode_filename"
    t.string   "warehouse_place"
    t.decimal  "buying_price",                           :precision => 10, :scale => 2
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "status"
    t.integer  "brand_id"
    t.decimal  "stock_trigal",                           :precision => 10, :scale => 2
    t.decimal  "stock_polo",                             :precision => 10, :scale => 2
    t.string   "age"
    t.decimal  "height",                                 :precision => 10, :scale => 2
    t.decimal  "width",                                  :precision => 10, :scale => 2
    t.decimal  "weight",                                 :precision => 10, :scale => 2
    t.decimal  "length",                                 :precision => 10, :scale => 2
    t.string   "sex"
    t.integer  "age_from"
    t.integer  "age_to"
    t.decimal  "stock_almacen",                          :precision => 10, :scale => 2
    t.decimal  "stock_clarisa",                          :precision => 10, :scale => 2
    t.boolean  "print_description"
    t.integer  "stock_trigal_compromised",                                              :default => 0
    t.integer  "stock_polo_compromised",                                                :default => 0
    t.integer  "stock_almacen_compromised",                                             :default => 0
    t.integer  "stock_carisa_compromised",                                              :default => 0
    t.decimal  "corporative_price",                      :precision => 10, :scale => 2
    t.boolean  "delta",                                                                 :default => false
    t.decimal  "min_stock",                              :precision => 10, :scale => 2
    t.boolean  "for_import"
    t.decimal  "special_price",                          :precision => 10, :scale => 2
    t.string   "note"
    t.boolean  "available_sale"
    t.integer  "sale_discount"
    t.string   "sale_description"
  end

  add_index "products", ["brand_id"], :name => "brand_id"
  add_index "products", ["category_id"], :name => "category_id"
  add_index "products", ["code"], :name => "code"
  add_index "products", ["code"], :name => "index_products_on_code"
  add_index "products", ["subcategory_id"], :name => "subcategory_id"

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ruc"
    t.string   "contact_person"
  end

  create_table "quote_detail_versions", :force => true do |t|
    t.integer  "quote_detail_id"
    t.integer  "version"
    t.integer  "quote_id",                  :limit => 8
    t.integer  "product_id",                :limit => 8
    t.integer  "quantity",                  :limit => 8
    t.string   "product_detail"
    t.datetime "updated_at"
    t.integer  "from",                      :limit => 8
    t.integer  "to",                        :limit => 8
    t.integer  "age_from",                  :limit => 8
    t.integer  "age_to",                    :limit => 8
    t.decimal  "price",                                  :precision => 10, :scale => 2
    t.boolean  "from_web"
    t.boolean  "additional"
    t.string   "sex"
    t.integer  "pending"
    t.integer  "stock_from_almacen"
    t.integer  "stock_from_carisa"
    t.integer  "stock_from_trigal"
    t.integer  "stock_from_polo"
    t.boolean  "unavailable"
    t.integer  "stock_trigal_compromised",                                              :default => 0
    t.integer  "stock_polo_compromised",                                                :default => 0
    t.integer  "stock_almacen_compromised",                                             :default => 0
    t.integer  "stock_carisa_compromised",                                              :default => 0
    t.integer  "pack_number"
    t.boolean  "months"
  end

  add_index "quote_detail_versions", ["product_id"], :name => "product_id"
  add_index "quote_detail_versions", ["quote_detail_id"], :name => "quote_detail_id"
  add_index "quote_detail_versions", ["quote_id"], :name => "quote_id"

  create_table "quote_details", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "product_id"
    t.decimal  "quantity",                  :precision => 10, :scale => 2
    t.string   "product_detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from"
    t.integer  "to"
    t.integer  "age_from"
    t.integer  "age_to"
    t.decimal  "price",                     :precision => 10, :scale => 2
    t.integer  "version"
    t.boolean  "from_web"
    t.boolean  "additional"
    t.string   "sex"
    t.integer  "pending"
    t.integer  "stock_from_almacen"
    t.integer  "stock_from_carisa"
    t.integer  "stock_from_trigal"
    t.integer  "stock_from_polo"
    t.boolean  "unavailable"
    t.integer  "stock_trigal_compromised",                                 :default => 0
    t.integer  "stock_polo_compromised",                                   :default => 0
    t.integer  "stock_almacen_compromised",                                :default => 0
    t.integer  "stock_carisa_compromised",                                 :default => 0
    t.integer  "pack_number"
    t.boolean  "months"
  end

  add_index "quote_details", ["product_id"], :name => "product_id"
  add_index "quote_details", ["quote_id"], :name => "quote_id"

  create_table "quotes", :force => true do |t|
    t.integer  "client_id"
    t.integer  "store_id"
    t.integer  "user_id"
    t.string   "client_address"
    t.datetime "quote_date"
    t.integer  "duration"
    t.string   "sending_details"
    t.text     "quote_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document"
    t.string   "status"
    t.string   "contact_name"
    t.string   "price_type"
    t.boolean  "updated"
    t.boolean  "sent"
    t.integer  "child_number"
    t.decimal  "budget",              :precision => 10, :scale => 2
    t.boolean  "is_requested"
    t.boolean  "orders_generated"
    t.integer  "quote_details_count",                                :default => 0
    t.boolean  "from_web"
  end

  add_index "quotes", ["client_id"], :name => "index_quotes_on_client_id"
  add_index "quotes", ["status"], :name => "index_quotes_on_status"
  add_index "quotes", ["store_id"], :name => "index_quotes_on_store_id"
  add_index "quotes", ["user_id"], :name => "index_quotes_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "send_order_details", :force => true do |t|
    t.integer  "product_id",       :limit => 8
    t.integer  "send_order_id",    :limit => 8
    t.decimal  "quantity",                      :precision => 10, :scale => 2
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_quantity", :limit => 8
  end

  add_index "send_order_details", ["product_id"], :name => "product_id"
  add_index "send_order_details", ["send_order_id"], :name => "send_order_id"

  create_table "send_orders", :force => true do |t|
    t.integer  "owner_id",                 :limit => 8
    t.integer  "store_id",                 :limit => 8
    t.datetime "send_date"
    t.integer  "user_id",                  :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "received_date"
    t.string   "document"
    t.string   "sending_type"
    t.integer  "send_order_details_count",              :default => 0
  end

  add_index "send_orders", ["owner_id"], :name => "index_send_orders_on_owner_id"
  add_index "send_orders", ["store_id"], :name => "index_send_orders_on_store_id"

  create_table "sending_guide_details", :force => true do |t|
    t.integer  "sending_guide_id"
    t.integer  "product_id"
    t.decimal  "quantity",                       :precision => 10, :scale => 2
    t.integer  "price",            :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "pending"
  end

  add_index "sending_guide_details", ["product_id"], :name => "product_id"
  add_index "sending_guide_details", ["sending_guide_id"], :name => "sending_guide_id"

  create_table "sending_guides", :force => true do |t|
    t.integer  "store_id"
    t.integer  "client_id"
    t.datetime "sending_date"
    t.string   "driver_name"
    t.string   "license_plate"
    t.string   "truck_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document"
    t.string   "status"
    t.string   "delivery_address"
    t.string   "delivery_contact"
    t.string   "delivery_phone"
    t.boolean  "unload_stock"
    t.string   "sending_type"
  end

  add_index "sending_guides", ["client_id"], :name => "index_sending_guides_on_client_id"
  add_index "sending_guides", ["store_id"], :name => "index_sending_guides_on_store_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "description"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ruc"
    t.decimal  "cash_amount",           :precision => 10, :scale => 2
    t.decimal  "yesterday_cash_amount", :precision => 10, :scale => 2
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.integer  "equivalent_unit_id", :limit => 8
    t.integer  "equivalence",        :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "role_id"
    t.string   "password"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["store_id"], :name => "index_users_on_store_id"
  add_index "users", ["username"], :name => "index_users_on_username"

end
