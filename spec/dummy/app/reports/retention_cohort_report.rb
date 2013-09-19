include ReportCat::Core
include ReportCat::Reports

class RetentionCohortReport < CohortReport

  def initialize( attributes = {} )
    defaults = {
        :name => :retention_cohort_report,
        :other => RetentionReport.new
    }

    super( defaults.merge( attributes ) )
  end


end