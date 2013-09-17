module ReportCat
  module Core
    class Column

      attr_reader :name, :type, :sql

      def initialize( attributes = {} )
        @name = attributes[ :name ]
        @type = attributes[ :type ]
        @sql = attributes[ :sql ]
      end

      def format( value )
        return nil if value.nil?

        case @type
          when :float then return ("%.2f" % value).to_f
          when :integer then return value.to_i
          else return value
        end
      end

    end
  end
end
