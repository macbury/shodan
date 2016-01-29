class CreateHumiditiers < ActiveRecord::Migration
  def change
    create_table :humidifiers do |t|
      t.float   :min_humidity,  default: 36.0
      t.integer :max_shots,     default: 6
      t.integer :shot_duration, default: 30
      t.integer :shot_left,     default: 6
      t.integer :sleep_duration, default: 10
      t.integer :start_command, null: false
      t.integer :stop_command, null: false
      t.datetime    :next_tick_at
      t.string  :state,         default: 'check_env'
      t.timestamps
    end
    
  end
end
