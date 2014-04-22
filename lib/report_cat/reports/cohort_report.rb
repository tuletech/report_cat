module ReportCat
  module Reports
    include ReportCat::Core

    class CohortReport < DateRangeReport

      attr_reader :cohort

      def initialize( attributes = {} )
        defaults = { :name => :cohort_report }
        super( defaults.merge( attributes ) )

        add_column( :total, :integer )

        if @cohort = attributes[ :cohort ]
          @cohort.params.each { |p| @params << p unless param( p.name ) }
        end
       end

      def query
        @rows = []

        period = param( :period ).value.to_sym
        start_date = param( :start_date ).value
        stop_date = param( :stop_date ).value
        name = param( :period ).value.to_s.chop.chop

        DateRange.generate( period, start_date, stop_date )
        range = DateRange.range( period, start_date, stop_date )

        range.each_index { |i| add_column( "#{name}_#{i+1}", :float ) }
        range.each { |r| @rows << add_row( r, range ) }

        columns = @columns[ 3, @columns.length - 3 ].map { |c| c.name }
        add_chart( :cohort_line, :line, :start_date, columns )

        add_edit_column
      end

      def add_row( date_range, column_range )
        return [] unless cohort

        generate_cohort( date_range )

        i_total = cohort.column_index( :total )
        total = cohort.rows.empty? ? 0 : cohort.rows[ 0 ][ i_total ]
        row = [ date_range.start_date, date_range.stop_date, total ]

        column_range.each_index do |i|
          if i >= cohort.rows.size
            row << nil
          else
            row << process_cohort( cohort.rows[ i ] )
          end
        end

        return row
      end

      def generate_cohort( date_range )
        cohort.param( :period ).value = date_range.period.to_sym
        cohort.param( :start_date ).value = date_range.start_date
        cohort.param( :stop_date ).value = param( :stop_date ).value
        cohort.generate
      end

      def process_cohort( row )
        return raw_cohort( row )
      end

      def raw_cohort( row )
        i_total = cohort.column_index( :total )
        value = row[ i_total ].to_f
        return ("%.2f" % value).to_f
      end

      def fractional_cohort( row )
        i_total = cohort.column_index( :total )
        total = cohort.rows.empty? ? 0 : cohort.rows[ 0 ][ i_total ]

        value = row[ i_total ].to_f
        value = ( total == 0 ? 0.0 : value / total )
        return ("%.2f" % value).to_f
      end

      def add_edit_column
        i_start = cohort.column_index( :start_date )
        add_column( :edit, :report )

        @rows.each do |row|
          start_date = row[ i_start ]
          row << {
              :name => @cohort.name,
              :start_date => start_date,
              :stop_date => param( :stop_date ).value,
              :period => param( :period ).value
          }
        end
      end

    end

  end
end
