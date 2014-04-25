module ReportCat
  module Reports
    include ReportCat::Core

    class DateRangeReport < Report

      PERIODS = [ :daily, :weekly, :monthly, :quarterly, :yearly ].freeze

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
        add_param( :period, :select, :weekly, :values => PERIODS )
        add_param( :group, :check_box )

        table_name = ReportCat::DateRange.table_name
        add_column( :start_date, :date, :sql => "#{table_name}.start_date" )
        add_column( :stop_date, :date, :sql => "#{table_name}.stop_date" )
      end

      def query
        DateRange.generate( period, start_date, stop_date )
        super
      end

      def where
        return [
            DateRange.sql_intersect( start_date, stop_date ),
            DateRange.sql_period( period )
        ].join( ' and ' )
      end

      def group_by
        @group_by if group?
      end

      # Accessors

      def period
        param( :period ).value.to_sym
      end

      def start_date
        param( :start_date ).value
      end

      def stop_date
        param( :stop_date ).value
      end

      def group?
        param( :group ).value
      end

      def first_period
        ReportCat::DateRange.range( period, start_date, stop_date ).first
      end

    end

  end
end