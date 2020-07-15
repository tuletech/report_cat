module ReportCat

  describe DateRange do

    before( :each ) do
      @period = :daily
      @start_date = Date.civil( 2013, 9, 15 )
      @stop_date = Date.civil( 2013, 9, 18 )
    end

    #############################################################################
    # ::generate

    describe '::generate' do

      it 'iterates the periods in the date range' do
        expect( DateRange ).to receive( :iterate ).with( @period, @start_date, @stop_date )
        DateRange.generate( @period, @start_date, @stop_date )
      end

      it 'creates entries for each period' do
        expected = ( @stop_date - @start_date ).to_i + 1

        expect( DateRange.count ).to eql( 0 )
        DateRange.generate( @period, @start_date, @stop_date )
        expect( DateRange.count ).to eql( expected )

        (@start_date..@stop_date).each do |date|
          date_range = DateRange.where( :period => @period, :start_date => date, :stop_date => date ).first
          expect( date_range ).to be_present
          expect( date_range.period ).to eql( @period.to_s )
          expect( date_range.start_date ).to eql( date )
          expect( date_range.stop_date ).to eql( date )
        end
      end

      it 'does not create entries that already exist' do
        DateRange.generate( @period, @start_date, @stop_date )
        expect( DateRange ).to_not receive( :create )
        DateRange.generate( @period, @start_date, @stop_date )
      end
    end

    #############################################################################
    # ::iterate

    describe '::iterate' do

      it 'iterates the requests date range and yields the start and stop times for each period' do
        expected = @stop_date - @start_date + 1
        expect { |b| DateRange.iterate( @period, @start_date, @stop_date, &b) }.to yield_control.exactly( expected ).times
      end

      it 'iterates daily' do
        expect { |b| DateRange.iterate( :daily, '2013-01-01', '2013-12-31', &b) }.to yield_control.exactly( 365 ).times
      end

      it 'iterates weekly' do
        expect { |b| DateRange.iterate( :weekly, '2013-01-01', '2013-12-31', &b) }.to yield_control.exactly( 53 ).times
      end

      it 'iterates monthly' do
        expect { |b| DateRange.iterate( :monthly, '2013-01-01', '2013-12-31', &b) }.to yield_control.exactly( 12 ).times
      end

      it 'iterates quarterly' do
        expect { |b| DateRange.iterate( :quarterly, '2013-01-01', '2013-12-31', &b) }.to yield_control.exactly( 4 ).times
      end

      it 'iterates yearly' do
        expect { |b| DateRange.iterate( :yearly, '2013-01-01', '2013-12-31', &b) }.to yield_control.exactly( 1 ).times
      end

      it 'raises an except for an unknown period' do
        expect { |b| DateRange.iterate( :hourly, '2013-01-01', '2013-12-31', &b) }.to raise_error( 'Unknown date range: hourly' )
      end
    end

    #############################################################################
    # ::join_*

    describe 'joins' do

      before( :each ) do
        @table = 'users'
        @column = 'created_at'
      end

      describe '::join_to' do

        it 'generates a join string' do
          expected = "join users on date( users.created_at ) between report_cat_date_ranges.start_date and report_cat_date_ranges.stop_date"
          expect( DateRange.join_to( @table, @column ) ).to eql( expected )
        end
      end

      describe '::join_before' do

        it 'generates a join string' do
          expected = "join users on date( users.created_at ) <= report_cat_date_ranges.stop_date"
          expect( DateRange.join_before( @table, @column ) ).to eql( expected )
        end
      end

      describe '::join_after' do

        it 'generates a join string' do
          expected = "join users on date( users.created_at ) > report_cat_date_ranges.stop_date"
          expect( DateRange.join_after( @table, @column ) ).to eql( expected )
        end
      end
    end

    #############################################################################
    # ::sql_*

    describe '::sql_intersect' do

      it 'generates date intersection sql' do
        expect( DateRange.sql_intersect( '2013-09-01', '2013-09-18' ) ).to eql_file( 'spec/data/models/sql_intersect.sql')
      end
    end

    describe '::sql_period' do

      it 'generate query sql' do
        expected = "report_cat_date_ranges.period = 'weekly'"
        expect( DateRange.sql_period( :weekly ) ).to eql( expected )
      end
    end
  end
end