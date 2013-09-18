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
          when :float then return ("%.2f" % value).to_f
          when :integer then return value.to_i
          else return value
        end
      end

      def to_sql
        sql = @options[ :sql ]
        return "#{sql} as #{name}" if sql
        return 0 if @type == :ratio
        return @name
      end

    end
  end
end
