module ReportCat
  class ReportsController < ApplicationController

    before_filter :set_reports

    def index
    end

    def show
      @report = @reports[ params[ :id ] ]
    end

  protected

    def set_reports
      @reports = get_reports
    end

    def get_reports
      reports = HashWithIndifferentAccess.new

      ReportCat::Core::Report.descendants.map do |klass|
        report = klass.new
        @reports[ report.name.to_sym ] = report
      end

      return reports
    end

  end
end
