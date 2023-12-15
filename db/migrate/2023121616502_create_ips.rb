Sequel.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table(:ips) do
      column    :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      String    :address, null: false
      String    :version, null: true
      TrueClass :enabled, null: false, default: false
      Timestamp :created_at, default: Sequel.lit("now()"), null: false
      Timestamp :updated_at, default: Sequel.lit("now()"), null: false

      index :id, unique: true
    end
  end
end
