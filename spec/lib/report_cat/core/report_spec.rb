require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Report do

    include SetupReports

    before( :each ) do
      @name = :test
      @report = Report.new( :name => @name )
    end

    describe '#initialize' do

      it 'initializes accessor values' do
        @report.name.should eql( @name )
        @report.params.should eql( [] )
        @report.columns.should eql( [] )
        @report.rows.should eql( [] )
        @report.charts.should eql( [] )
      end

    end

    describe '#add_param' do

      it 'adds a param' do
        @report.params.should be_empty
        @report.add_param( :foo, :integer )
        @report.params.size.should eql( 1 )
      end

    end

    describe '#param' do

      before( :each ) do
        @param = @report.add_param( :foo, :integer )
      end

      it 'finds a parameter by name' do
        @report.param( :foo ).should be( @param )
      end

      it 'returns nil if it can not find it' do
        @report.param( :bar ).should be_nil
      end

    end

    describe '#add_column' do

      it 'adds a column' do
        @report.columns.should be_empty
        @report.add_column( :foo, :integer )
        @report.columns.size.should eql( 1 )
      end

    end

    describe '#generate' do

      before( :each ) do
        setup_reports
        @report.stub( :query ).and_return( nil )
      end

      it 'applies passed in options to params of the same name' do
        @report.param( :text_field_test ).value.should be_nil
        @report.generate( :text_field_test => 'foobar' )
        @report.param( :text_field_test ).value.should eql( 'foobar' )
      end

      it 'calls pre_process before query' do
        @report.should_receive( :pre_process )
        @report.generate
      end

      it 'calls query' do
        @report.should_receive( :query ).and_return( nil )
        @report.generate
      end

      it 'calls post_process after query' do
        @report.should_receive( :post_process )
        @report.generate
      end

    end

    describe '#query' do

      before( :each ) do
        setup_reports
       end

      it 'initializes rows' do
        @report.rows << []
        @report.rows.size.should > 0

        @report.should_receive( :to_sql ).and_return( nil )
        ActiveRecord::Base.connection.stub( :execute ).and_return( nil )

        @report.send( :query )
        @report.rows.size.should eql( 0 )
      end

      it 'executes SQL against ActiveRecord' do
        sql = 'foobar
'
        @report.should_receive( :to_sql ).and_return( sql )
        ActiveRecord::Base.connection.should_receive( :execute ).with( sql ).and_return( nil )
        @report.send( :query )
      end

      it 'tolerates nil results from ActiveRecord' do
        @report.should_receive( :to_sql ).and_return( nil )
        ActiveRecord::Base.connection.stub( :execute ).and_return( nil )
        @report.send( :query )
      end

      it 'populates rows with the results of the query' do
        results = [ [1], [2] ]

        @report.should_receive( :to_sql ).and_return( nil )
        ActiveRecord::Base.connection.stub( :execute ).and_return( results )
        @report.send( :query )
        @report.rows.size.should eql( results.size )
        results.each_index { |i| @report.rows[ i ].should eql( results[ i ] ) }
      end

    end

  end

end
