module ReportCat
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

    def generate( options = {} )
      @params.each { |param| param.value = options[ param.name ] if options[ param.name ] }

      pre_process if defined?( pre_process )
      query
      post_process if defined?( post_process )
    end

  protected

    def query
      if results = ActiveRecord::Base.connection.execute( to_sql )
        results.each { |row| @rows << row  }
      end
    end

  end
end
