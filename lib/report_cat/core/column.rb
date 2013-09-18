module ReportCat
  module Core
    class Column

      attr_reader :name, :type, :options

      def initialize( attributes = {} )
        @name = attributes[ :name ]
        @type = attributes[ :type ]
        @options = attributes[ :options ] || {}
      end

      def format( value )
        return nil if value.nil?

        case @type
          when :float          then return ("%.2f" % value).to_f
          when :integer        then return value.to_i
          when :moving_average then return ("%.2f" % value).to_f
          when :ratio          then return ("%.2f" % value).to_f
          else return value
        end
      end

      def post_process( report )
        case @type
          when :moving_average then post_process_moving_average( report )
          when :ratio          then post_process_ratio( report )
        end
      end

      def post_process_moving_average( report )
        i_moving_average = report.column_index( name )
        i_target = report.column_index( @options[ :target ] )

        interval = @options[ :interval ]
        interval_max = interval - 1
        n_rows = report.rows.length - 1

        (interval_max..n_rows).each do |row|
          sum = 0.0
          (0..interval_max).each { |i| sum += report.rows[ row - i ][ i_target ] }
          value = sum / interval
          report.rows[ row ][ i_moving_average ] = format( value )
        end
      end

      def post_process_ratio( report )
        i_ratio = report.column_index( name )
        i_numerator = report.column_index( @options[ :numerator ] )
        i_denominator = report.column_index( @options[ :denominator ] )

        report.rows.each do |row|
          numerator = row[ i_numerator ].to_f
          denominator = row[ i_denominator ].to_f
          value = ( denominator == 0.0 ) ? 0.0 : ( numerator / denominator )
          row[ i_ratio ] = format( value )
        end
      end

      def to_sql
        sql = @options[ :sql ]
        return "#{sql} as #{name}" if sql
        return "0 as #{name}" if @type == :ratio || @type == :moving_average
        return @name
      end

    end
  end
end
