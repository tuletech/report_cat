module ReportCat
  module Core
    class Param

      attr_reader :name, :type, :value, :options

      def initialize( attributes = {} )
        @name = attributes[ :name ]
        @type = attributes[ :type ]
        @value = attributes[ :value ]
        @options = attributes[ :options ]
      end

      def value=( value )
        @value = case @type
          when :check_box then ( value == '1' )
          when :date
            if value.kind_of?( Hash )
              Date.new( value[:year].to_i, value[:month].to_i, value[:day].to_i )
            else
              Date.parse( value )
            end
          else value
        end
      end

    end
  end
end
