class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :activated
      t.timestamps
    end
  end
end
