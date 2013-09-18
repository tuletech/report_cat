require 'spec_helper'

module ReportCat

  describe DateRange do

    before( :each ) do
      @period = :daily
      @start_date = Date.civil( 2013, 9, 15 )
      @stop_date = Date.civil( 2013, 9, 18 )
    end

    it 'defines supported time periods' do
      DateRange::PERIODS.should eql( [ :daily, :weekly, :monthly, :quarterly, :yearly ] )
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

    end

    #############################################################################
    # ::generate

    describe '::generate' do

      it 'iterates the periods in the date range' do
        DateRange.should_receive( :iterate ).with( @period, @start_date, @stop_date )
        DateRange.generate( @period, @start_date, @stop_date )
      end

      it 'finds or creates entries for each period' do
        expected = @stop_date - @start_date + 1

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

    end

  end

end