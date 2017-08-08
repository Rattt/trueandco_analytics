class CreateMetricUsers < ActiveRecord::Migration[5.1]
  def up
    drop_table :metric_users if (table_exists? :metric_users)
    create_table :metric_users do |t|
      t.integer :user_id, null: false, default: 0
      t.timestamp :datetime_create, null: false
      t.timestamp :last_active_datetime, null: false
    end

    add_column :metric_users, :hash_id, 'integer unsigned', null: false

    add_index(:metric_users, :user_id)
    add_index(:metric_users, :hash_id)
  end

  def down
    drop_table :metric_users
  end
end
