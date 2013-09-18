class CreateDateRanges < ActiveRecord::Migration
  def change
    create_table :report_cat_date_ranges do |t|
      t.date :start_date
      t.date :stop_date
      t.string :period

      t.index [ :period, :start_date, :stop_date ], :unique => true, :name => 'index_report_cat_date_ranges_on_period_and_dates'
      t.index [ :period, :stop_date ]
    end
  end
end
