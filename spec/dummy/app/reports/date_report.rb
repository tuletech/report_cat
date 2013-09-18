include ReportCat::Core

class DateReport < Report

  def initialize
    super( :name => :date_report, :from => 'report_cat_date_ranges' )

    periods = [ 'all' ] + ReportCat::DateRange::PERIODS.map { |p| p.to_s }

    add_param( :start_date, :date, Date.today - 7 )
    add_param( :stop_date, :date, Date.today )
    add_param( :period, :select, :monthly, periods )

    add_column( :start_date, :date )
    add_column( :stop_date, :date )
    add_column( :period, :string )
  end

  def where
    start_date = param( :start_date ).value
    stop_date = param( :stop_date ).value
    period = param( :period ).value.to_sym

    sql =<<-EOSQL
      (
        report_cat_date_ranges.start_date between '#{start_date}' and '#{stop_date}'
        or
        report_cat_date_ranges.stop_date between '#{start_date}' and '#{stop_date}'
        or
        '#{start_date}' between report_cat_date_ranges.start_date and report_cat_date_ranges.stop_date
        or
        '#{stop_date}' between report_cat_date_ranges.start_date and report_cat_date_ranges.stop_date
      )
    EOSQL

    if ReportCat::DateRange::PERIODS.include?( period )
      sql += "and report_cat_date_ranges.period = '#{period}'"
    end
  end

end