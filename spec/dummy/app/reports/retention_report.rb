include ReportCat::Core
include ReportCat::Reports

class RetentionReport < DateRangeReport

  def initialize
    super(
        :name => :retention_report,
        :joins => [
            ReportCat::DateRange.join_to( :visits, :created_at ),
            'join users on users.id = visits.user_id'
        ].join( ' ' )
    )

    add_column( :total, :integer, :sql => 'count( distinct visits.user_id )' )
    add_chart( :retention_line, :line, :start_date, :total )
  end

  def where
    sql = super

    start_date = param( :start_date ).value
    stop_date = param( :stop_date ).value
    period = param( :period ).value.to_sym

    first =  ReportCat::DateRange.range( period, start_date, stop_date ).first

    sql += "and users.created_at between '#{first.start_date}' and '#{first.stop_date}'"

    return sql
  end

end