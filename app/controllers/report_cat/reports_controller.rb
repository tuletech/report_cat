module ReportCat
  class ReportsController < ApplicationController

    layout :set_layout

    before_filter :_authenticate!
    before_filter :_authorize!
    before_filter :set_reports

    def index
    end

    def show
      @report = @reports[ params[ :id ] ]
      @report.generate( params )

      respond_to do |format|
        format.html
        format.csv { render :text => @report.to_csv, :content_type => 'text/csv' }
      end
    end

  protected

    def set_reports
      @reports = get_reports
    end

    def get_reports
      reports = HashWithIndifferentAccess.new

      ReportCat::Core::Report.descendants.map do |klass|
        report = klass.new
        reports[ report.name.to_sym ] = report
      end

      return reports
    end

    def set_layout
      return ReportCat.config.layout
    end

    def _authenticate!
      instance_eval( &ReportCat.config.authenticate_with )
    end

    def _authorize!
      instance_eval( &ReportCat.config.authorize_with )
    end

  end
end
