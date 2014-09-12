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
        expect( @chart.name ).to eql( @name )
        expect( @chart.type ).to eql( @type )
        expect( @chart.label ).to eql( @label )
        expect( @chart.values ).to eql( @values )
        expect( @chart.options ).to eql( @options )
      end

    end

    #############################################################################
    # #columns

    describe '#columns' do

      it 'generates json' do
        expect( @chart.columns( @report ) ).to eql_file( 'spec/data/lib/chart_columns.json' )
      end

    end

    #############################################################################
    # #initialize

    describe '#data' do

      it 'generates json' do
        setup_reports
        expect( @chart.data( @report ) ).to eql_file( 'spec/data/lib/chart_data.json' )
      end

    end

  end
end
