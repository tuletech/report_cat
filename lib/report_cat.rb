require "report_cat/engine"
require "report_cat/config"

require 'report_cat/core/chart'
require 'report_cat/core/column'
require 'report_cat/core/param'
require 'report_cat/core/report'

require 'report_cat/reports/date_range_report'
require 'report_cat/reports/cohort_report'

if defined?( RSpec )
  require 'report_cat/matchers/have_chart'
  require 'report_cat/matchers/have_column'
  require 'report_cat/matchers/have_param'
end

module ReportCat

  def self.config
    return ReportCat::Config.instance
  end

  def self.configure
    yield config
  end

end
