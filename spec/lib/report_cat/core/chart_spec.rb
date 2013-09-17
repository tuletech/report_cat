require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Chart do

    before( :each ) do
      @name = :test
      @type = :select
      @label = Column.new
      @values = [ Column.new, Column.new ]
      @options = {}
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        chart = Chart.new(
            :name => @name,
            :type => @type,
            :label => @label,
            :values => @values,
            :options => @options
        )

        chart.name.should eql( @name )
        chart.type.should eql( @type )
        chart.label.should eql( @label )
        chart.values.should eql( @values )
        chart.options.should eql( @options )
      end

    end

  end
end
