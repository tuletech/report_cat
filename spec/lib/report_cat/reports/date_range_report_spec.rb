require 'spec_helper'

module ReportCat
  module Reports

    describe DateRangeReport do

      before( :each ) do
        @report = DateRangeReport.new

        @table_name = ReportCat::DateRange.table_name
        @defaults = {
            :name => :date_range_report,
            :from => @table_name,
            :order_by => "#{@table_name}.start_date asc",
            :group_by => "#{@table_name}.start_date, #{@table_name}.stop_date"
        }

        @period = :weekly
        @start_date = Date.civil( 2013, 9, 1 )
        @stop_date = Date.civil( 2013, 9, 18 )

        @report.param( :period ).value = @period
        @report.param( :start_date ).value = @start_date
        @report.param( :stop_date ).value = @stop_date
      end

      it 'defines supported time periods' do
        expected = [ :daily, :weekly, :monthly, :quarterly, :yearly ]
        expect(  DateRangeReport::PERIODS ).to eql( expected )
      end

      #############################################################################
      # defaults

      describe '#defaults' do

        it 'defines default report values' do
          expect( @report.defaults ).to eql( @defaults )
        end

      end

      #############################################################################
      # initialize

      describe '#initialize' do

        it 'merges default values' do
          name = :test
          @report = DateRangeReport.new( :name => name )
          expect( @report.name ).to be( name )
        end

        it 'defines params' do
          expect( @report.params.size ).to eql( 3 )
          expect( @report ).to have_param( :start_date ).with_type( :date ).with_value( @start_date )
          expect( @report ).to have_param( :stop_date ).with_type( :date ).with_value( @stop_date )
          expect( @report ).to have_param( :period ).with_type( :select ).with_value( :weekly ).with_options( :values => DateRangeReport::PERIODS )
        end

        it 'defines columns' do
          expect( @report.columns.size ).to eql( 2 )
          expect( @report ).to have_column( :start_date ).with_type( :date ).with_options( :sql => "report_cat_date_ranges.start_date" )
          expect( @report ).to have_column( :stop_date ).with_type( :date ).with_options( :sql => "report_cat_date_ranges.stop_date" )
        end

      end

      #############################################################################
      # query

      describe '#query' do

        it 'generates the required date ranges' do
          expect( DateRange ).to receive( :generate ).with( @period, @start_date, @stop_date )
          @report.query
        end

        it 'calls query on its super' do
          expect( @report ).to receive( :to_sql ).and_return( 'select 1' )
          @report.query
        end

      end

      #############################################################################
      # where

      describe '#where' do

        it 'generates sql' do
          expect( @report.where ).to eql_file( 'spec/data/lib/date_range_report_where.sql')
        end

        it 'includes the preconfigured where clause' do
          where = '1 = 1'
          @report = DateRangeReport.new( :where => where )
          expect( @report.where ).to include( where )
        end

      end

      #############################################################################
      # accessors

      describe 'accessors' do

        it 'has param accessors' do
          expect( @report.period ).to eql( @report.param( :period ).value.to_sym )
          expect( @report.start_date ).to eql( @report.param( :start_date ).value )
          expect( @report.stop_date ).to eql( @report.param( :stop_date ).value )
        end

        it 'has a first_period accessor' do
          expected = ReportCat::DateRange.range( @report.period, @report.start_date, @report.stop_date ).first
          expect( @report.first_period ).to eql( expected )
        end

      end

    end

  end
end