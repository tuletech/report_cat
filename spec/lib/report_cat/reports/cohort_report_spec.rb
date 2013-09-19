require 'spec_helper'

module ReportCat
  module Reports

    describe CohortReport do

      before( :each ) do
        @other = DateRangeReport.new
        @other.add_column( :total, :integer, :sql => '0' )
        @other.add_param( :foo, :integer )
        @other.add_param( :bar, :string )

        @period = :weekly
        @start_date = Date.civil( 2013, 1, 1 )
        @stop_date = Date.civil( 2013, 1, 31 )

        @report = CohortReport.new( :other => @other )
        @report.param( :start_date ).value =  @start_date
        @report.param( :stop_date ).value = @stop_date
        @report.param( :period ).value =  @period

        @range = DateRange.range( @period, @start_date, @stop_date )
      end

      describe '#initialize' do

        it 'uses a default name'  do
          @report.name.should eql( :cohort_report )
        end

        it 'adds a total column' do
          @report.column( :total ).should be_present
        end

        it 'merges in any non-duplicate params from the other report' do
          @report.param( :foo ).should be_present
          @report.param( :bar ).should be_present
        end

      end

      describe '#query' do

        it 'raises an exception if the other report has not been set' do
          @report = CohortReport.new
          expect { @report.query }.to raise_error( 'Missing cohort report: cohort_report' )
        end

        it 'adds columns for each date range' do
          @report.query
          @report.columns.size.should eql( 3 + @range.size )
        end

        it 'adds rows for each date range' do
          @report.query
          @report.rows.size.should eql( @range.size )
        end

        it 'adds a line chart of all its columns' do
          @report.query
          @report.charts.size.should eql( 1 )
        end

      end

      describe '#add_row' do

        before( :each ) do
          DateRange.generate( @period, @start_date, @stop_date )
        end

        it 'returns the generates row' do
          @report.add_row( @range.first, @range ).should be_an_instance_of( Array )
        end

        it 'generates the other report for this cohort' do
          @report.should_receive( :generate_cohort )
          @report.add_row( @range.first, @range )
        end

        it 'sets the first three columns to start, stop, total' do
          @report.add_row( @range.first, @range )
          @report.columns[ 0 ].name.should eql( :start_date )
          @report.columns[ 1 ].name.should eql( :stop_date )
          @report.columns[ 2 ].name.should eql( :total )
        end

        it 'fills in the columns by date range' do
          row = @report.add_row( @range.first, @range )
          row.should be_an_instance_of( Array )
          row.size.should eql( @range.size + 3 )
        end

        it 'fills nil when there is no data' do
          @report.other.stub( :rows ).and_return( [] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should be_nil
        end

        it 'fills with the ratio to total' do
          @report.other.stub( :rows ).and_return( [ [ '', '', 30 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should eql( 1.0 )
        end

        it 'tolerates total being 0' do
          @report.other.stub( :rows ).and_return( [ [ '', '', 0 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should eql( 0.0 )
        end

      end

      describe '#generate_cohort' do

        before( :each ) do
          DateRange.generate( @period, @start_date, @stop_date )
        end

        it 'initializes the start, stop, and period of the other report' do
          @report.other.param( :period ).value = :monthly
          @report.other.param( :start_date ).value = Date.civil( 2012, 1, 1)
          @report.other.param( :stop_date ).value = Date.civil( 2012, 1, 1)

          @report.generate_cohort( @range.first )

          @report.other.param( :period ).value.should eql( @report.param( :period ).value )
          @report.other.param( :start_date ).value.should eql( @range.first.start_date )
          @report.other.param( :stop_date ).value.should eql( @report.param( :stop_date ).value )
        end

        it 'generates the other report' do
          @report.other.should_receive( :generate )
          @report.generate_cohort( @range.first )
        end

      end

    end
  end
end