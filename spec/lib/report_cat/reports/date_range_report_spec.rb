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
        DateRangeReport::PERIODS.should eql( expected )
      end

      #############################################################################
      # #defaults

      describe '#defaults' do

        it 'defines default report values' do
          @report.defaults.should eql( @defaults )
        end

      end

      #############################################################################
      # #initialize

      describe '#initialize' do

        it 'merges default values' do
          name = :test
          @report = DateRangeReport.new( :name => name )
          @report.name.should be( name )
        end

        it 'defines params' do
          @report.params.size.should eql( 3 )
          @report.param( :start_date ).should be_present
          @report.param( :stop_date ).should be_present
          @report.param( :period ).should be_present
        end

        it 'defines columns' do
          @report.columns.size.should eql( 2 )
          @report.column( :start_date ).should be_present
          @report.column( :stop_date ).should be_present

          expected = "report_cat_date_ranges.start_date as start_date"
          @report.column( :start_date ).to_sql.should eql( expected )

          expected = "report_cat_date_ranges.stop_date as stop_date"
          @report.column( :stop_date ).to_sql.should eql( expected )
        end

      end

      #############################################################################
      # #query

      describe '#query' do

        it 'generates the required date ranges' do
          DateRange.should_receive( :generate ).with( @period, @start_date, @stop_date )
          @report.query
        end

        it 'calls query on its super' do
          @report.should_receive( :to_sql ).and_return( 'select 1' )
          @report.query
        end

      end

      #############################################################################
      # #where

      describe '#where' do

        it 'generates sql' do
          @report.where.should eql_file( 'spec/data/lib/date_range_report_where.sql')
        end
      end

    end

  end
end