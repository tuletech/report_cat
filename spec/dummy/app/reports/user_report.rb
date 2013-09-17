
include ReportCat::Core

class UserReport < Report

  def initialize
    super( :name => :user_report )

    @day_column = Column.new( :name => :day, :type => :date, :sql => 'date( created_at )' )
    @total_column = Column.new( :name => :total, :type => :integer, :sql => 'count( id )' )
  end

  def to_sql
      'select date( created_at ) as day, count( id ) as total from users group by date( created_at )'
  end

end
