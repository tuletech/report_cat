module ReportCat
  module Reports
    include ReportCat::Core

    class CohortReport < DateRangeReport

      def initialize( attributes = {} )
        super( { :abstract => true }.merge( attributes ) )
      end

    end

  end
end