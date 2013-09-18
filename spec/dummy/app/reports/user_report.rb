include ReportCat::Core

class UserReport < Report

  def initialize
    super( :name => :user_report, :from => 'users', :group_by => 'date( created_at )' )

    add_param( :start_date, :date, Date.today - 7 )
    add_param( :stop_date, :date, Date.today )

    add_column( :day, :date, :sql => 'date( created_at )' )
    add_column( :total, :integer, :sql => 'count( id )' )
    add_column( :total_ma_2, :moving_average, :target => :total, :interval => 2 )
    add_column( :activated, :integer, :sql => 'sum( activated == "t" )' )
    add_column( :activated_to_total, :ratio, :numerator => :activated, :denominator => :total )

    add_chart( :pie_test, :pie, :day, [ :total, :activated ] )
    add_chart( :bar_test, :bar, :day, [ :total, :activated ] )
    add_chart( :line_test, :line, :day, [ :total, :activated ] )
  end

  def post_process

  end

end
