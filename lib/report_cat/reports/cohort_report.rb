module ReportCat
  module Reports
    include ReportCat::Core

    class CohortReport < DateRangeReport

      attr_reader :other

      def initialize( attributes = {} )
        defaults = { :name => :cohort_report }
        super( defaults.merge( attributes ) )

        add_column( :total, :integer )

        if @other = attributes[ :other ]
          @other.params.each { |p| @params << p unless param( p.name ) }
        end
       end

      def query
        @rows = []

        raise "Missing cohort report: #{name}" unless @other

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
      end

      def add_row( date_range, column_range )
        generate_cohort( date_range )

        i_total = other.column_index( :total )
        total = other.rows.empty? ? 0 : other.rows[ 0 ][ i_total ]
        row = [ date_range.start_date, date_range.stop_date, total ]

        column_range.each_index do |i|
          if i >= other.rows.size
            row << nil
          else
            value = other.rows[ i ][ i_total ].to_f
            value = ( total == 0 ? 0.0 : value / total )
            row << ("%.2f" % value).to_f
          end
        end

        return row
      end

      def generate_cohort( date_range )
        other.param( :period ).value = date_range.period.to_sym
        other.param( :start_date ).value = date_range.start_date
        other.param( :stop_date ).value = param( :stop_date ).value
        other.generate
      end

    end

  end
end
