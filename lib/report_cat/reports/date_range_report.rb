module ReportCat
  module Reports
    include ReportCat::Core

    class DateRangeReport < Report

      PERIODS = [ :daily, :weekly, :monthly, :quarterly, :yearly ]

      def defaults
        table_name = ReportCat::DateRange.table_name

        return {
            :name => :date_range_report,
            :from => table_name,
            :order_by => "#{table_name}.start_date asc",
            :group_by => "#{table_name}.start_date, #{table_name}.stop_date"
        }
      end

      def initialize( attributes = {} )
        super( defaults.merge( attributes ) )

        add_param( :start_date, :date, Date.today - 7 )
        add_param( :stop_date, :date, Date.today )
        add_param( :period, :select, :weekly, PERIODS )

        table_name = ReportCat::DateRange.table_name
        add_column( :start_date, :date, :sql => "#{table_name}.start_date" )
        add_column( :stop_date, :date, :sql => "#{table_name}.stop_date" )
      end

      def pre_process
        period = param( :period ).value.to_sym
        start_date = param( :start_date ).value
        stop_date = param( :stop_date ).value

        DateRange.generate( period, start_date, stop_date )
      end

      def where
        start_date = param( :start_date ).value
        stop_date = param( :stop_date ).value
        period = param( :period ).value.to_sym

        sql = [ DateRange.sql_intersect( start_date, stop_date ) ]
        sql << DateRange.sql_period( period ) if PERIODS.include?( period )
        sql.join( ' and ' )
      end

    end

  end
end