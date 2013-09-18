include ReportCat::Core
include ReportCat

class DateReport < Report

  def initialize
    super( :name => :date_report, :from => 'report_cat_date_ranges', :order_by => 'start_date asc' )

    periods = ReportCat::DateRange::PERIODS.map { |p| p.to_s }

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

    sql = [ DateRange.sql_intersect( start_date, stop_date ) ]
    sql << DateRange.sql_period( period ) if DateRange::PERIODS.include?( period )
    sql.join( ' and ' )
  end

  def pre_process
    period = param( :period ).value.to_sym
    start_date = param( :start_date ).value
    stop_date = param( :stop_date ).value

    DateRange.generate( period, start_date, stop_date )
  end

end