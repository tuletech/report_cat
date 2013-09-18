require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Column do

    before( :each ) do
      @name = :test
      @type = :select
      @options = { :sql => 'max( something )' }
    end

    #############################################################################
    # #initialize

    describe '#initialize' do

      it 'initializes accessor values' do
        column = Column.new( :name => @name, :type => @type, :options => @options )
        column.name.should eql( @name )
        column.type.should eql( @type )
        column.options.should eql( @options )
      end

    end

    #############################################################################
    # #format

    describe '#format' do

      it 'formats floats' do
        value = 22.0 / 7.0
        expected = ("%.2f" % value).to_f
        column = Column.new( :name => @name, :type => :float )
        column.format( value ).should eql( expected )
      end


      it 'formats integers' do
        value = '727'
        expected = value.to_i
        column = Column.new( :name => @name, :type => :integer )
        column.format( value ).should eql( expected )

      end

      it 'passes everything else through' do
        value = '727'
        column = Column.new( :name => @name, :type => :string )
        column.format( value ).should eql( value )
      end

    end

    #############################################################################
    # #post_process

    describe '#post_process' do

      before( :each ) do
        @report = Report.new
      end

      it 'handles moving averages' do
        column = Column.new( :name => @name, :type => :moving_average )
        column.should_receive( :post_process_moving_average ).with( @report )
        column.post_process( @report )
      end

      it 'handles ratios' do
        column = Column.new( :name => @name, :type => :ratio )
        column.should_receive( :post_process_ratio ).with( @report )
        column.post_process( @report )
      end

    end

    #############################################################################
    # #post_process_moving_average

    describe '#post_process_moving_average' do

      it 'fills in moving average values' do
        @report = Report.new
        @report.add_column( :value, :integer )

        @report.rows[ 0 ] =  [ 1, 0 ]
        @report.rows[ 1 ] =  [ 2, 0 ]
        @report.rows[ 2 ] =  [ 4, 0 ]

        column =  @report.add_column( :ma, :moving_average, :target => :value, :interval => 2 )
        column.post_process( @report )

        @report.rows[ 0 ][ 1 ].should eql( 0 )
        @report.rows[ 1 ][ 1 ].should eql( 1.5 )
        @report.rows[ 2 ][ 1 ].should eql( 3.0 )
      end

    end

    #############################################################################
    # #post_process_moving_average

    describe '#post_process_ratio' do

      it 'fills in ratio values' do
        @report = Report.new
        @report.add_column( :n, :integer )
        @report.add_column( :d, :integer )

        @report.rows[ 0 ] =  [ 1, 2, 0 ]
        @report.rows[ 1 ] =  [ 3, 4, 0 ]
        @report.rows[ 2 ] =  [ 4, 0, 0 ]

        column =  @report.add_column( :r, :ratio, :numerator => :n, :denominator => :d )
        column.post_process( @report )

        @report.rows[ 0 ][ 2 ].should eql( 0.5 )
        @report.rows[ 1 ][ 2 ].should eql( 0.75 )
        @report.rows[ 2 ][ 2 ].should eql( 0.0 )
      end

    end

    #############################################################################
    # #to_sql

    describe '#to_sql' do

      it 'uses raw sql if provided in options' do
        sql = 'count( id )'
        column = Column.new( :name => @name, :type => :integer, :options => { :sql => sql } )
        column.to_sql.should eql( "#{sql} as #{@name}" )
      end


      it 'uses 0 for calculated columns' do
        column = Column.new( :name => @name, :type => :moving_average )
        column.to_sql.should eql( "0 as #{@name}" )

        column = Column.new( :name => @name, :type => :ratio )
        column.to_sql.should eql( "0 as #{@name}" )
      end

      it 'uses the column name as a last resort' do
        column = Column.new( :name => @name, :type => :integer )
        column.to_sql.should eql( @name )
      end

    end

  end
end
