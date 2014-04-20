require "report_cat/engine"
require "report_cat/config"

require 'report_cat/core/chart'
require 'report_cat/core/column'
require 'report_cat/core/param'
require 'report_cat/core/report'

require 'report_cat/reports/date_range_report'
require 'report_cat/reports/cohort_report'

module ReportCat

  def self.config
    return ReportCat::Config.instance
  end

  def self.configure
    yield config
  end

end
