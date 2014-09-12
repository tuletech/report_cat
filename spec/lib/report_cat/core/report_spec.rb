require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Report do

    include SetupReports

    before( :each ) do
      @name = :test
      @report = Report.new( :name => @name )
    end

    #############################################################################
    # initialize

    describe '#initialize' do

      it 'initializes accessor values' do
        expect( @report.name ).to eql( @name )
        expect( @report.params ).to eql( [] )
        expect( @report.columns ).to eql( [] )
        expect( @report.rows ).to eql( [] )
        expect( @report.charts ).to eql( [] )
      end

      it 'accepts arrays' do
        array = [ 'a', 'b' ]

        report = Report.new(
            :from => array,
            :joins => array,
            :where => array,
            :group_by => array,
            :order_by => array
        )

        expect( report.from ).to eql( 'a,b' )
        expect( report.joins ).to eql( 'a b' )
        expect( report.where ).to eql( 'a and b' )
        expect( report.group_by ).to eql( 'a,b' )
        expect( report.order_by ).to eql( 'a,b' )
      end

    end

    #############################################################################
    # accept_array

    describe '#accept_array' do

      it 'joins arrays with the separator' do
        expected = '1,2,3'
        expect( @report.accept_array( [ '1', '2', '3' ], ',' ) ).to eql( expected )
      end

      it 'returns non arrays' do
        expect( @report.accept_array( 1, ',' ) ).to eql( 1 )
        expect( @report.accept_array( :foo, ',' ) ).to eql( :foo )
      end

    end

    #############################################################################
    # add_chart

    describe '#add_chart' do

      it 'adds a chart' do
        name = :i_like_pie
        type = :pie
        label = :label
        values = [ :value_1, :value_2 ]
        options = { :sweet => true }

        expect( @report.charts ).to be_empty
        @report.add_chart( name, type, label, values, options )
        expect( @report.charts.size ).to eql( 1 )

        chart = @report.charts.first

        expect( chart ).to be_an_instance_of( Chart )
        expect( chart.name ).to eql( name )
        expect( chart.type ).to eql( type )
        expect( chart.label ).to eql( label )
        expect( chart.values ).to eql( values )
        expect( chart.options ).to eql( options )
      end

    end

    #############################################################################
    # add_column

    describe '#add_column' do

      it 'adds a column' do
        name = :foo
        type = :integer
        options = { :sql => 'count( 1 )' }

        expect( @report.columns ).to be_empty
        @report.add_column( name, type, options )
        expect( @report.columns.size ).to eql( 1 )

        column = @report.columns.first
        expect( column.name ).to eql( name )
        expect( column.type ).to eql( type )
        expect( column.options ).to eql( options )
      end

    end

    #############################################################################
    # add_param

    describe '#add_param' do

      it 'adds a param' do
        name = :foo
        type = :integer

        expect( @report.params ).to be_empty
        @report.add_param( name, type )
        expect( @report.params.size ).to eql( 1 )

        param = @report.params.first
        expect( param ).to be_an_instance_of( Param )
        expect( param.name ).to eql( name )
        expect( param.type ).to eql( type )
      end

    end

    #############################################################################
    # column

    describe '#column' do

      before( :each ) do
        setup_reports
      end

      it 'returns the named column' do
        expect( @report.columns.size ).to be > 1
        @report.columns.each_index do |i|
          column = @report.columns[ i ]
          expect( @report.column( column.name ) ).to eql( column )
        end

      end


      it 'returns nil if it is unable to find the column' do
        expect( @report.column( :does_not_exist ) ).to be_nil
      end

    end


    #############################################################################
    # column_index

    describe '#column_index' do

      before( :each ) do
        setup_reports
      end

      it 'returns the index of the named column' do
        expect( @report.columns.size ).to be > 1
        @report.columns.each_index do |i|
          column = @report.columns[ i ]
          expect( @report.column_index( column.name ) ).to eql( i )
        end

      end


      it 'returns nil if it is unable to find the column' do
        expect( @report.column_index( :does_not_exist ) ).to be_nil
      end

    end


    #############################################################################
    # generate

    describe '#generate' do

      before( :each ) do
        setup_reports
        allow( @report ).to receive( :query ).and_return( nil )
      end

      it 'applies passed in options to params of the same name' do
        expect( @report.param( :text_field_test ).value ).to be_nil
        @report.generate( :text_field_test => 'foobar' )
        expect( @report.param( :text_field_test ).value ).to eql( 'foobar' )
      end

    end

    #############################################################################
    # param

    describe '#param' do

      before( :each ) do
        @param = @report.add_param( :foo, :integer )
      end

      it 'finds a parameter by name' do
        expect( @report.param( :foo ) ).to be( @param )
      end

      it 'returns nil if it can not find it' do
        expect( @report.param( :bar ) ).to be_nil
      end

    end

    #############################################################################
    # to_csv

    describe '#to_csv' do

      before( :each ) do
        setup_reports
        allow( @report ).to receive( :query ).and_return( nil )
      end

      it 'generates CSV' do
        expect( @report.to_csv ).to eql_file( 'spec/data/lib/report.csv' )
      end

    end

    #############################################################################
    # attributes

    describe '#attributes' do

      before( :each ) do
        setup_reports
      end

      it 'includes the name as both name and id' do
        expect( @report.attributes[ :id ] ).to eql( @report.name )
        expect( @report.attributes[ :name ] ).to eql( @report.name )
      end

      it 'includes back if defined' do
        back = @report.attributes
        expect( @report.attributes.has_key?( :back ) ).to be( false )
        @report.back = back
        expect( @report.attributes[ :back ] ).to eql( back )
      end

      it 'returns a hash of param names to values' do
        @report.params.each do |param|
          expect( @report.attributes[ param.name ] ).to eql( param.value )
        end
      end

    end

    #############################################################################
    # query

    describe '#query' do

      before( :each ) do
        setup_reports
       end

      it 'initializes rows' do
        @report.rows << []
        expect( @report.rows.size ).to be > 0

        expect( @report ).to receive( :to_sql ).and_return( nil )
        allow( ActiveRecord::Base.connection ).to receive( :execute ).and_return( nil )

        @report.send( :query )
        expect( @report.rows.size ).to eql( 0 )
      end

      it 'executes SQL against ActiveRecord' do
        sql = 'foobar
'
        expect( @report ).to receive( :to_sql ).and_return( sql )
        expect( ActiveRecord::Base.connection ).to receive( :execute ).with( sql ).and_return( nil )
        @report.send( :query )
      end

      it 'tolerates nil results from ActiveRecord' do
        expect( @report ).to receive( :to_sql ).and_return( nil )
        expect( ActiveRecord::Base.connection ).to receive( :execute ).and_return( nil )
        @report.send( :query )
      end

      it 'populates rows with the results of the query' do
        results = [ [1], [2] ]

        expect( @report ).to receive( :to_sql ).and_return( nil )
        expect( ActiveRecord::Base.connection ).to receive( :execute ).and_return( results )
        @report.send( :query )
        expect( @report.rows.size ).to eql( results.size )
        results.each_index { |i| expect( @report.rows[ i ] ).to eql( results[ i ] ) }
      end

      it 'post processes each column' do
        expect( ActiveRecord::Base.connection ).to receive( :execute ).and_return( [] )

        @report.columns.each { |c| expect( c ).to receive( :post_process ).with( @report ) }
        @report.send( :query )
      end

    end

    #############################################################################
    # to_sql

    describe '#to_sql' do

      before( :each ) do
        setup_reports
        allow( @report ).to receive( :query ).and_return( nil )
      end

      it 'generates SQL' do
        expect( @report.send( :to_sql ) ).to eql_file( 'spec/data/lib/report.sql' )
      end

    end

  end

end
