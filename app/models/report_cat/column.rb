module ReportCat
  class Column

    attr_reader :name, :type, :sql

    def initialize( attributes = {} )
      @name = attributes[ :name ]
      @type = attributes[ :type ]
      @sql = attributes[ :sql ]
    end

  end
end
