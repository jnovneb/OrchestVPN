# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_25_090229) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "vpnName"
    t.string "name"
    t.string "desc"
    t.string "cert"
    t.string "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.integer "vpn_id", default: 1, null: false
    t.binary "file"
    t.index ["vpn_id"], name: "index_clients_on_vpn_id"
  end

  create_table "servers", force: :cascade do |t|
    t.string "name"
    t.string "CAcert"
    t.string "CAkey"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "user"
    t.string "vpn_admin_List"
    t.boolean "admin_vpn"
    t.string "vpn_list"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_vpns", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "vpn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin_vpn", default: false
    t.index ["user_id", "vpn_id"], name: "index_users_vpns_on_user_id_and_vpn_id", unique: true
    t.index ["user_id"], name: "index_users_vpns_on_user_id"
    t.index ["vpn_id"], name: "index_users_vpns_on_vpn_id"
  end

  create_table "vpns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vpn"
    t.string "name"
    t.string "description"
    t.string "protocol"
    t.integer "port"
    t.string "options"
    t.string "certificate"
    t.string "version"
    t.string "VPNAdminList"
    t.string "users"
    t.string "vpn_admin_list"
    t.integer "bandwidth"
    t.string "CIDR"
    t.integer "server_id", default: 1, null: false
    t.string "hostkey"
    t.string "managementPort"
    t.index ["port", "managementPort"], name: "index_vpns_on_port_and_management_port", unique: true
    t.index ["server_id"], name: "index_vpns_on_server_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clients", "vpns", on_delete: :cascade
  add_foreign_key "users_vpns", "users"
  add_foreign_key "users_vpns", "vpns"
  add_foreign_key "vpns", "servers"
end
