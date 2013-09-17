module ReportCat
  class Param

    attr_reader :name, :type, :value, :options

    def initialize( attributes = {} )
      @name = attributes[ :name ]
      @type = attributes[ :type ]
      @value = attributes[ :value ]
      @options = attributes[ :options ]
    end

  end
end
