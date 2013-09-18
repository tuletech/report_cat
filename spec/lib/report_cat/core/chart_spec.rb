require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Chart do

    include SetupReports

    before( :each ) do
      setup_reports

      @name = :test
      @type = :select
      @label = @report.columns.first.name.to_sym
      @values = @report.columns.map { |c| c.name.to_sym }
      @options = {}

      @chart = Chart.new(
                  :name => @name,
                  :type => @type,
                  :label => @label,
                  :values => @values,
                  :options => @options )
    end

    #############################################################################
    # #initialize

    describe '#initialize' do

      it 'initializes accessor values' do
        @chart.name.should eql( @name )
        @chart.type.should eql( @type )
        @chart.label.should eql( @label )
        @chart.values.should eql( @values )
        @chart.options.should eql( @options )
      end

    end

    #############################################################################
    # #columns

    describe '#data' do

      it 'generates json' do
        @chart.columns( @report ).should eql_file( 'spec/data/chart_columns.json' )
      end

    end

    #############################################################################
    # #initialize

    describe '#data' do

      it 'generates json' do
        setup_reports
        @chart.data( @report ).should eql_file( 'spec/data/chart_data.json' )
      end

    end

  end
end
