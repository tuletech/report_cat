include ReportCat::Core
include ReportCat::Reports

class UserReport < DateRangeReport

  def initialize
    super(
        :name => :user_report,
        :joins => ReportCat::DateRange.join_to( :users, :created_at )
    )

    add_column( :total, :integer, :sql => 'count( users.id )' )
    add_column( :total_ma_2, :moving_average, :target => :total, :interval => 2 )
    add_column( :activated, :integer, :sql => 'sum( users.activated == "t" )' )
    add_column( :activated_to_total, :ratio, :numerator => :activated, :denominator => :total )
    add_column( :extra, :integer, :sql => 'null', :hidden => true )

    add_chart( :pie_test, :pie, :start_date, [ :total, :activated ] )
    add_chart( :bar_test, :bar, :start_date, [ :total, :activated ] )
    add_chart( :line_test, :line, :start_date, [ :total, :activated ] )
  end

end
