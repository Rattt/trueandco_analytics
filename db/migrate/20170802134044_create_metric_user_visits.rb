class CreateMetricUserVisits < ActiveRecord::Migration[5.1]
  def up
    drop_table :metric_user_visits if (table_exists? :metric_user_visits)
    create_table :metric_user_visits do |t|
      t.integer  :metric_user_id, null: false, default: 0
      t.integer  :metric_user_session_id, null: false, default: 0
      t.string   :page_path, null: false
      t.boolean  :is_buy, null: false, default: false
      t.text     :user_action, null: false
    end
    add_column :metric_user_visits, :time_s, 'mediumint unsigned', null: false, default: 0

    add_index(:metric_user_visits, :metric_user_id)
    add_index(:metric_user_visits, :metric_user_session_id)
  end

  def down
    drop_table :metric_user_visits
  end
end
