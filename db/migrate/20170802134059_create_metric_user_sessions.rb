class CreateMetricUserSessions < ActiveRecord::Migration[5.1]
  def up
    drop_table :metric_user_sessions if (table_exists? :metric_user_sessions)
    create_table   :metric_user_sessions do |t|
      t.integer    :metric_user_id, null: false, default: 0
      t.binary     :ip_6, limit: 16, null: false, default: 0
      t.string     :user_agent, null: false
      t.string     :referer, null: false
      t.boolean    :is_mobile, null: false, default: false
      t.string     :browser, null: false, default: ''
      t.timestamp  :session_start, null: false
    end

    add_column :metric_user_sessions, :ip_4, 'integer unsigned', null: false, default: 0
    add_column :metric_user_sessions, :live_time_s, 'integer unsigned', null: false

    add_index(:metric_user_sessions, :metric_user_id)
    add_index(:metric_user_sessions, :ip_4)
    add_index(:metric_user_sessions, :session_start)
  end

  def down
    drop_table :metric_user_sessions
  end
end


