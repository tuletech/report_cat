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

  end

end
