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
       end

    end
  end
end
