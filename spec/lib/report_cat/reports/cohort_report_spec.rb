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
          expect( @report.name ).to eql( :cohort_report )
        end

        it 'adds a total column' do
          expect( @report ).to have_column( :total ).with_type( :integer )
        end

        it 'merges in any non-duplicate params from the cohort report' do
          expect( @report ).to have_param( :foo ).with_type( :integer )
          expect( @report ).to have_param( :bar ).with_type( :string )
        end

        it 'defaults cohort_column to :total' do
          expect( @report.cohort_column ).to eql( :total )
        end

        it 'accepts cohort_column as an attribute' do
          @report = CohortReport.new( :cohort_column => :test )
          expect( @report.cohort_column ).to eql( :test )
        end
      end

      #############################################################################
      # query

      describe '#query' do

        it 'adds columns for each date range' do
          @report.query
          expect( @report.columns.size ).to eql( 4 + @range.size )
        end

        it 'adds rows for each date range' do
          @report.query
          expect( @report.rows.size ).to eql( @range.size )
        end

        it 'adds a line chart of all its columns' do
          @report.query
          expect( @report.charts.size ).to eql( 1 )
          expect( @report ).to have_chart( :cohort_line ).with_type( :line )
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
          expect( @report.add_row( @range.first, @range ) ).to be_an_instance_of( Array )
        end

        it 'generates the report for this cohort' do
          expect(  @report ).to receive( :generate_cohort )
          @report.add_row( @range.first, @range )
        end

        it 'sets the first three columns to start, stop, total' do
          @report.add_row( @range.first, @range )
          expect( @report.columns[ 0 ].name ).to eql( :start_date )
          expect( @report.columns[ 1 ].name ).to eql( :stop_date )
          expect( @report.columns[ 2 ].name ).to eql( :total )
        end

        it 'fills in the columns by date range' do
          row = @report.add_row( @range.first, @range )
          expect( row ).to be_an_instance_of( Array )
          expect( row.size ).to eql( @range.size + 3 )
        end

        it 'fills nil when there is no data' do
          allow( @report.cohort ).to receive( :rows ).and_return( [] )
          row = @report.add_row( @range.first, @range )
          expect( row[ 3 ] ).to be_nil
        end

        it 'fills with the total value' do
          allow( @report.cohort ).to receive( :rows ).and_return( [ [ '', '', 30 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          expect( row[ 3 ] ).to eql( 30.0 )
        end

        it 'tolerates total being 0' do
          allow( @report.cohort ).to receive( :rows ).and_return( [ [ '', '', 0 ], [ '', '', 20 ], [ '', '', 10 ] ] )
          row = @report.add_row( @range.first, @range )
          expect( row[ 3 ] ).to eql( 0.0 )
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

          expect( @report.cohort.param( :period ).value ).to eql( @report.param( :period ).value )
          expect( @report.cohort.param( :start_date ).value ).to eql( @range.first.start_date )
          expect( @report.cohort.param( :stop_date ).value ).to eql( @report.param( :stop_date ).value )
        end

        it 'generates the cohort report' do
          expect( @report.cohort ).to receive( :generate )
          @report.generate_cohort( @range.first )
        end
      end

      #############################################################################
      # add_link_column

      describe '#add_link_column' do

        before( :each ) do
          allow( @report ).to receive( :rows ).and_return( [ [ Date.parse( '2014-04-22' ), nil, nil ] ] )
          @report.add_link_column
        end

        it 'adds a link column' do
          expect( @report ).to have_column( :link ).with_type( :report )
        end

        it 'populates the link column' do
          i_link = @report.column_index( :link )
          i_start = @report.column_index( :start_date )

          @report.rows.each do |row|
            start_date = row[ i_start ]
            expect( row[ i_link ] ).to eql( @report.cohort_link( start_date ) )
          end
        end
      end

      #############################################################################
      # cohort_link

      describe '#cohort_link' do

        it 'gets the cohort attributes as a hash' do
          start_date =  @report.param( :start_date ).value
          cohort_link = @report.cohort_link( start_date )

          expect( cohort_link[ :name ] ).to eql( @report.cohort.name )
          expect( cohort_link[ :id ] ).to eql( @report.cohort.name )
          expect( cohort_link[ :start_date ] ).to eql( start_date )
          expect( cohort_link[ :stop_date ] ).to eql( @report.param( :stop_date ).value )
          expect( cohort_link[ :period ] ).to eql( @report.param( :period ).value )
          expect( cohort_link[ :back ] ).to eql( @report.attributes )
        end

        it 'accepts link attributes to override the report values' do
          link_attributes = { :period => :foobar }
          start_date =  @report.param( :start_date ).value
          cohort_link = @report.cohort_link( start_date, link_attributes )
          expect( cohort_link[ :period ] ).to eql( :foobar )
        end
      end
    end
  end
end