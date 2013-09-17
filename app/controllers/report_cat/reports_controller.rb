module ReportCat
  class ReportsController < ApplicationController

    def index
      @reports = ReportCat::Core::Report.descendants.map { |klass| klass.new.name.to_sym }.sort
    end

  end
end
