module ReportCat
  module Core
    class Chart

      attr_reader :name, :type, :label, :values, :options

      def initialize( attributes = {} )
        @name = attributes[ :name ]
        @type = attributes[ :type ]
        @label = attributes[ :label ]
        @values = attributes[ :values ]
        @options = attributes[ :options ]

        @values = [ @values ] unless @values.is_a?( Array )
       end

      def columns( report )
        columns = []
        columns << [ 'string', @label ]
        @values.each { |name| columns << [ 'number', name  ] }

        return columns.to_json
      end

      def data( report )
        table = []

        label_index = report.column_index( @label )
        raise "Bad label index: #{@label}" unless label_index

        value_indexes = @values.map { |name| report.column_index( name ) }

        report.rows.each do |row|
          data = [ row[ label_index ].to_s ]
          value_indexes.each do |value_index|
            data << row[ value_index ]
          end
          table << data
        end

        return table.to_json
      end

    end
  end
end
