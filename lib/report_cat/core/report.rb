module ReportCat
  module Core
    class Report
      extend ActiveSupport::DescendantsTracker

      attr_reader :name, :params, :columns, :rows, :charts

      def initialize( attributes = {} )
        @name = attributes[ :name ]

        @params = []
        @columns = []
        @rows = []
        @charts = []
      end

      def add_chart( name, type, label, values, options = {} )
        chart = Chart.new(
            :name => name,
            :type => type,
            :label => label,
            :values => values,
            :options => options )

        charts << chart
        return chart
      end

      def add_column( name, type, sql = nil )
        columns << ( column = Column.new( :name => name, :type => type, :sql => sql ) )
        return column
      end

      def add_param( name, type, value = nil, options = {} )
        params << ( param = Param.new( :name => name, :type => type, :value => value, :options => options ) )
        return param
      end

      def column( name )
        if index = columns.index { |c| c.name.to_s == name.to_s }
          return columns[ index ]
        end
        return nil
      end

      def column_index( name )
        @columns.each_index { |index| return index if columns[ index ].name == name }
        return nil
      end

      def generate( options = {} )
        @params.each { |param| param.value = options[ param.name ] if options[ param.name ] }

        pre_process if defined?( pre_process )
        query
        post_process if defined?( post_process )
      end

      def param( name )
        if index = @params.index { |p| p.name.to_s == name.to_s }
          return @params[ index ]
        end
        return nil
      end

    protected

      def query
        @rows = []
        if results = ActiveRecord::Base.connection.execute( to_sql )
          results.each do |row|
            if row.is_a?( Hash )
              row = columns.map { |c| row[ c.name.to_s ] }
            end

            # Format each columns

            row.each_index { |i| row[ i ] = columns[ i ].format( row[ i ] ) }

            @rows << row
          end
        end
      end

      def to_sql
        # TODO implement

        'select 1'
      end

    end
  end
end
