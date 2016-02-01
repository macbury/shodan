class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uid
      t.datetime :next_timeout
    end
  end
end
