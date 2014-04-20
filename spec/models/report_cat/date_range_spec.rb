require 'spec_helper'

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
        DateRange.should_receive( :iterate ).with( @period, @start_date, @stop_date )
        DateRange.generate( @period, @start_date, @stop_date )
      end

      it 'creates entries for each period' do
        expected = ( @stop_date - @start_date ).to_i + 1

        DateRange.count.should eql( 0 )
        DateRange.generate( @period, @start_date, @stop_date )
        DateRange.count.should eql( expected )

        (@start_date..@stop_date).each do |date|
          date_range = DateRange.where( :period => @period, :start_date => date, :stop_date => date ).first
          date_range.should be_present
          date_range.period.should eql( @period.to_s )
          date_range.start_date.should eql( date )
          date_range.stop_date.should eql( date )
        end
      end

      it 'does not create entries that already exist' do
        DateRange.generate( @period, @start_date, @stop_date )
        DateRange.should_not_receive( :create )
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
          DateRange.join_to( @table, @column ).should eql( expected )
        end

      end

      describe '::join_before' do

        it 'generates a join string' do
          expected = "join users on date( users.created_at ) <= report_cat_date_ranges.stop_date"
          DateRange.join_before( @table, @column ).should eql( expected )
        end

      end

      describe '::join_after' do

        it 'generates a join string' do
          expected = "join users on date( users.created_at ) > report_cat_date_ranges.stop_date"
          DateRange.join_after( @table, @column ).should eql( expected )
        end

      end

    end

    #############################################################################
    # ::sql_*

    describe '::sql_intersect' do

      it 'generates date intersection sql' do
        DateRange.sql_intersect( '2013-09-01', '2013-09-18' ).should eql_file( 'spec/data/models/sql_intersect.sql')
      end

    end

    describe '::sql_period' do

      it 'generate query sql' do
        expected = "report_cat_date_ranges.period = 'weekly'"
        DateRange.sql_period( :weekly ).should eql( expected )
      end

    end

  end

end