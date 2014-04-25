require 'spec_helper'

module ReportCat
  module Reports

    describe CohortReport do

      before( :each ) do
        @cohort = DateRangeReport.new
        @cohort.add_column( :total, :integer, :sql => '0' )
        @cohort.add_param( :foo, :integer )
        @cohort.add_param( :bar, :string )

        @period = :weekly
        @start_date = Date.civil( 2013, 1, 1 )
        @stop_date = Date.civil( 2013, 1, 31 )

        @report = CohortReport.new( :cohort => @cohort )
        @report.param( :start_date ).value =  @start_date
        @report.param( :stop_date ).value = @stop_date
        @report.param( :period ).value =  @period

        @range = DateRange.range( @period, @start_date, @stop_date )
      end

      #############################################################################
      # initialize

      describe '#initialize' do

        it 'uses a default name'  do
          @report.name.should eql( :cohort_report )
        end

        it 'adds a total column' do
          @report.should have_column( :total ).with_type( :integer )
        end

        it 'merges in any non-duplicate params from the cohort report' do
          @report.should have_param( :foo ).with_type( :integer )
          @report.should have_param( :bar ).with_type( :string )
        end

      end

      #############################################################################
      # query

      describe '#query' do

        it 'adds columns for each date range' do
          @report.query
          @report.columns.size.should eql( 4 + @range.size )
        end

        it 'adds rows for each date range' do
          @report.query
          @report.rows.size.should eql( @range.size )
        end

        it 'adds a line chart of all its columns' do
          @report.query
          @report.charts.size.should eql( 1 )
          @report.should have_chart( :cohort_line ).with_type( :line )
        end

        it 'adds an link column' do
          expect( @report.column( :link ) ).to be_nil
          @report.query
          expect( @report.column( :link ) ).to be_present
        end
      end

      #############################################################################
      # add_row

      describe '#add_row' do

        before( :each ) do
          DateRange.generate( @period, @start_date, @stop_date )
        end

        it 'returns the generates row' do
          @report.add_row( @range.first, @range ).should be_an_instance_of( Array )
        end

        it 'generates the report for this cohort' do
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
          @report.cohort.stub( :rows ).and_return( [] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should be_nil
        end

        it 'fills with the total value' do
          @report.cohort.stub( :rows ).and_return( [ [ '', '', 30 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should eql( 30.0 )
        end

        it 'tolerates total being 0' do
          @report.cohort.stub( :rows ).and_return( [ [ '', '', 0 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          row[ 3 ].should eql( 0.0 )
        end

      end

      #############################################################################
      # generate_cohort

      describe '#generate_cohort' do

        before( :each ) do
          DateRange.generate( @period, @start_date, @stop_date )
        end

        it 'initializes the start, stop, and period of the cohort report' do
          @report.cohort.param( :period ).value = :monthly
          @report.cohort.param( :start_date ).value = Date.civil( 2012, 1, 1)
          @report.cohort.param( :stop_date ).value = Date.civil( 2012, 1, 1)

          @report.generate_cohort( @range.first )

          @report.cohort.param( :period ).value.should eql( @report.param( :period ).value )
          @report.cohort.param( :start_date ).value.should eql( @range.first.start_date )
          @report.cohort.param( :stop_date ).value.should eql( @report.param( :stop_date ).value )
        end

        it 'generates the cohort report' do
          @report.cohort.should_receive( :generate )
          @report.generate_cohort( @range.first )
        end

      end

      #############################################################################
      # add_link_column

      describe '#add_link_column' do

        before( :each ) do
          @report.stub( :rows ).and_return( [ [ Date.parse( '2014-04-22' ), nil, nil ] ] )
          @report.add_link_column
        end

        it 'adds a link column' do
          expect( @report ).to have_column( :link ).with_type( :report )
        end

        it 'populates the link column' do
          i_link = @report.column_index( :link )
          i_start = @report.column_index( :start_date )

          @report.rows.each do |row|
            expect( row[ i_link ] ).to eql( @report.cohort_link( nil ) )
          end
        end

      end

      #############################################################################
      # cohort_link

      describe '#cohort_link' do

        it 'gets the cohort attributes as a hash' do
          expect( @report.cohort_link( nil )[ :name ] ).to eql( @report.cohort.name )
          expect( @report.cohort_link( nil )[ :id ] ).to eql( @report.cohort.name )
          expect( @report.cohort_link( nil )[ :start_date ] ).to eql(  @report.param( :start_date ).value )
          expect( @report.cohort_link( nil )[ :stop_date ] ).to eql(  @report.param( :stop_date ).value )
          expect( @report.cohort_link( nil )[ :period ] ).to eql(  @report.param( :period ).value )
          expect( @report.cohort_link( nil )[ :back ] ).to eql( @report.attributes )
        end

      end

    end
  end
end