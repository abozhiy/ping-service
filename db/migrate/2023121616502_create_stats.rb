Sequel.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table(:stats) do
      column    :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      column    :ip_id, :uuid, null: false
      Float     :rtt_min, null: false
      Float     :rtt_max, null: false
      Float     :rtt_avg, null: false
      Float     :rtt_stddev, null: false
      Float     :lost_packets, null: false
      Timestamp :created_at, default: Sequel.lit("now()"), null: false
      Timestamp :updated_at, default: Sequel.lit("now()"), null: false

      index :id, unique: true
      index :ip_id,
            name: :covering_index_stats_on_ip_id,
            include: [:rtt_min, :rtt_max, :rtt_avg, :rtt_stddev, :lost_packets]
    end
  end
end
