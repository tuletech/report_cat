class CreateDateRanges < ActiveRecord::Migration[4.2]
  def change
    create_table :report_cat_date_ranges do |t|
      t.date :start_date
      t.date :stop_date
      t.string :period

      t.index [ :period, :start_date ], :unique => true
      t.index [ :period, :stop_date ], :unique => true
      t.index [ :period, :start_date, :stop_date ], :unique => true, :name => 'index_report_cat_date_ranges_on_period_and_dates'
    end
  end
end
