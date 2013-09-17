require 'spec_helper'

include ReportCat::Core

module ReportCat::Core

  describe Report do

    before( :each ) do
      @name = :test
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        report = Report.new( :name => @name )
        report.name.should eql( @name )
        report.params.should eql( [] )
        report.columns.should eql( [] )
        report.rows.should eql( [] )
        report.charts.should eql( [] )
      end

    end

  end

end
