require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Param do

    before( :each ) do
      @name = :test
      @type = :select
      @value = 727
      @options = [ 314, 727 ]
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        param = Param.new( :name => @name, :type => @type, :value => @value, :options => @options )
        param.name.should eql( @name )
        param.type.should eql( @type )
        param.value.should eql( @value )
        param.options.should eql( @options )
      end

    end

  end

end
