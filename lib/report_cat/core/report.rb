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

      def add_param( name, type, value = nil, options = {} )
        params << ( param = Param.new( :name => name, :type => type, :value => value, :options => options ) )
        return param
      end

      def param( name )
        if index = params.index { |p| p.name.to_s == name.to_s }
          return params[ index ]
        end
        return nil
      end

      def add_column( name, type, sql = nil )
        columns << ( column = Column.new( :name => name, :type => type, :sql => sql ) )
        return column
      end

      def generate( options = {} )
        @params.each { |param| param.value = options[ param.name ] if options[ param.name ] }

        pre_process if defined?( pre_process )
        query
        post_process if defined?( post_process )
      end

    protected

      def query
        @rows = []
        if results = ActiveRecord::Base.connection.execute( to_sql )
          results.each { |row| @rows << row  }
        end
      end

    end
  end
end
