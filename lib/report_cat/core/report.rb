# This is the most basic report, a simple wrapped around an SQL generator

require 'csv'

module ReportCat
  module Core
    class Report
      extend ActiveSupport::DescendantsTracker

      attr_reader :name, :params, :columns, :rows, :charts
      attr_reader :from, :joins, :where, :group_by, :order_by, :limit
      attr_accessor :back
      attr_reader :abstract

      def initialize( attributes = {} )
        @name = attributes[ :name ]
        @from = accept_array( attributes[ :from ], ',' )
        @joins = accept_array( attributes[ :joins ], ' ' )
        @where = accept_array( attributes[ :where ], ' and ' )
        @group_by = accept_array( attributes[ :group_by ], ',' )
        @order_by = accept_array( attributes[ :order_by ], ',' )
        @limit = attributes[ :limit ]

        @back = attributes[ :back ]

        @params = []
        @columns = []
        @rows = []
        @charts = []
      end

      def accept_array( array, separator )
        return array unless array.is_a?( Array )
        return array.join( separator )
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

      def add_column( name, type, options = {} )
        columns << ( column = Column.new( :name => name, :type => type, :options => options ) )
        return column
      end

      def add_param( name, type, value = nil, options = {} )
        params << ( param = Param.new( :name => name, :type => type, :value => value, :options => options ) )
        return param
      end

      def attributes
        hash = { :id => name, :name => name }
        hash[ :back ] = @back if @back
        @params.each { |param| hash[ param.name ] = param.value }
        return hash
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
        query
      end

      def param( name )
        if index = @params.index { |p| p.name.to_s == name.to_s }
          return @params[ index ]
        end
        return nil
      end

      def to_csv
        CSV.generate( :force_quotes => true ) do |csv|
          csv << @columns.map { |column| column.name }
          @rows.each { |row| csv << row }
        end
      end

    protected

      def query
        @rows = []
        return unless results = ActiveRecord::Base.connection.execute( to_sql )

        results.each do |row|
          row = columns.map { |c| row[ c.name.to_s ] } if row.is_a?( Hash )
          row.each_index { |i| row[ i ] = columns[ i ].format( row[ i ] ) }
          @rows << row
        end

        @columns.each { |c| c.post_process( self ) }
      end

      def to_sql
        select = @columns.map { |c| c.to_sql }.compact.join( ',' )

        sql = "select #{select} from #{from}"
        sql << " #{joins}" if joins
        sql << " where #{where}" if where
        sql << " group by #{group_by}" if group_by
        sql << " order by #{order_by}" if order_by
        sql << " limit #{limit}" if limit

        return sql
      end

    end
  end
end
