module ReportCat
  class Report

    attr_reader :name, :params, :columns, :rows, :charts

    def initialize( attributes = {} )
      @name = attributes[ :name ]

      @params = []
      @columns = []
      @rows = []
      @charts = []
    end

  end
end
