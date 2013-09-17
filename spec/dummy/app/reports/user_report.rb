
include ReportCat::Core

class UserReport < Report

  def initialize
    super( :name => :user_report )

    @start_date = add_param( :start_date, :date, Date.today - 7 )
    @stop_date =  add_param( :stop_date, :date, Date.today )

    @day_column = add_column( :day, :date, 'date( created_at )' )
    @total_column = add_column( :total, :integer, 'count( id )' )

    @pie = add_chart( :pie, :pie, @day_column, @total_column )
    @bar = add_chart( :bar, :bar, @day_column, @total_column )
    @line = add_chart( :line, :line, @day_column, @total_column )
  end

  def to_sql
      'select date( created_at ) as day, count( id ) as total from users group by date( created_at )'
  end

end
