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
        expect( column.name ).to eql( @name )
        expect( column.type ).to eql( @type )
        expect( column.options ).to eql( @options )
      end
    end

    #############################################################################
    # #format

    describe '#format' do

      it 'formats floats' do
        value = 22.0 / 7.0
        expected = ("%.2f" % value).to_f
        column = Column.new( :name => @name, :type => :float )
        expect( column.format( value ) ).to eql( expected )
      end

      it 'formats integers' do
        value = '727'
        expected = value.to_i
        column = Column.new( :name => @name, :type => :integer )
        expect( column.format( value ) ).to eql( expected )
      end

      it 'passes everything else through' do
        value = '727'
        column = Column.new( :name => @name, :type => :string )
        expect( column.format( value ) ).to eql( value )
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
        expect( column ).to receive( :post_process_moving_average ).with( @report )
        column.post_process( @report )
      end

      it 'handles ratios' do
        column = Column.new( :name => @name, :type => :ratio )
        expect( column ).to receive( :post_process_ratio ).with( @report )
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

        expect( @report.rows[ 0 ][ 1 ] ).to eql( 0 )
        expect( @report.rows[ 1 ][ 1 ] ).to eql( 1.5 )
        expect( @report.rows[ 2 ][ 1 ] ).to eql( 3.0 )
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

        expect( @report.rows[ 0 ][ 2 ] ).to eql( 0.5 )
        expect( @report.rows[ 1 ][ 2 ] ).to eql( 0.75 )
        expect( @report.rows[ 2 ][ 2 ] ).to eql( 0.0 )
      end
    end

    #############################################################################
    # #to_sql

    describe '#to_sql' do

      it 'uses raw sql if provided in options' do
        sql = 'count( id )'
        column = Column.new( :name => @name, :type => :integer, :options => { :sql => sql } )
        expect( column.to_sql ).to eql( "#{sql} as #{@name}" )
      end

      it 'uses 0 for calculated columns' do
        column = Column.new( :name => @name, :type => :moving_average )
        expect( column.to_sql ).to eql( "0 as #{@name}" )

        column = Column.new( :name => @name, :type => :ratio )
        expect( column.to_sql ).to eql( "0 as #{@name}" )
      end

      it 'uses the column name as a last resort' do
        column = Column.new( :name => @name, :type => :integer )
        expect( column.to_sql ).to eql( @name )
      end
    end
  end
end
