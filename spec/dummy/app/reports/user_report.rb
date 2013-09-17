include ReportCat::Core

class UserReport < Report

  def initialize
    super( :name => :user_report, :from => 'users', :group_by => 'date( created_at )' )

    add_param( :start_date, :date, Date.today - 7 )
    add_param( :stop_date, :date, Date.today )

    @day_column = add_column( :day, :date, 'date( created_at )' )
    @total_column = add_column( :total, :integer, 'count( id )' )
    @activated_column = add_column( :activated, :integer, 'sum( activated == "t" )' )

    add_chart( :pie_test, :pie, :day_column, :total_column )
    add_chart( :bar_test, :bar, :day_column, :total_column )
    add_chart( :line_test, :line, :day_column, :total_column )
  end

end
