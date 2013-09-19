module ReportCat
  module Reports
    include ReportCat::Core

    class CohortReport < DateRangeReport

      def initialize( attributes = {} )
        defaults = { :name => :cohort_report }
        super( defaults.merge( attributes ) )

        if @report = attributes[ :report ]
          @report.params.each { |p| @params << p unless param( p.name ) }
        end

        add_column( :total, :integer )
      end

      def query
        @rows = []

        period = param( :period ).value.to_sym
        start_date = param( :start_date ).value
        stop_date = param( :stop_date ).value
        name = param( :period ).value.to_s.chop.chop
        range = DateRange.range( period, start_date, stop_date )

        range.each_index { |i| add_column( "#{name}_#{i+1}", :float ) }
        range.each { |r| @rows << add_row( r, range ) }

        columns = @columns[ 3, @columns.length - 3 ].map { |c| c.name }
        add_chart( :cohort_line, :line, :start_date, columns )
      end

      def add_row( date_range, column_range )
        row = [ date_range.start_date, date_range.stop_date ]
        return row  unless @report

        @report.param( :period ).value = date_range.period
        @report.param( :start_date ).value = date_range.start_date
        @report.param( :stop_date ).value = param( :stop_date ).value
        @report.generate

        i_total = @report.column_index( :total )
        total = @report.rows.empty? ? 0 : @report.rows[ 0 ][ i_total ]
        row << total

        column_range.each_index do |i|
          if i >= @report.rows.size
            row << nil
          else
            value = @report.rows[ i ][ i_total ].to_f
            value = ( total == 0 ? 0.0 : value / total )
            row << ("%.2f" % value).to_f
          end
        end

        return row
      end

    end

  end
end
