include ReportCat::Core

class UserReport < Report

  def initialize
    super( :name => :user_report, :from => 'users', :group_by => 'date( created_at )' )

    add_param( :start_date, :date, Date.today - 7 )
    add_param( :stop_date, :date, Date.today )

    add_column( :day, :date, 'date( created_at )' )
    add_column( :total, :integer, 'count( id )' )
    add_column( :activated, :integer, 'sum( activated == "t" )' )

    add_chart( :pie_test, :pie, :day, [ :total, :activated ] )
    add_chart( :bar_test, :bar, :day, [ :total, :activated ] )
    add_chart( :line_test, :line, :day, [ :total, :activated ] )
  end

end
