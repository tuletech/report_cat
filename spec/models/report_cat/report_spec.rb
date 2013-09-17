require 'spec_helper'

module ReportCat

  describe Report do

    before( :each ) do
      @name = :test
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        report = ReportCat::Report.new( :name => @name )
        report.name.should eql( @name )
        report.params.should eql( [] )
        report.columns.should eql( [] )
        report.rows.should eql( [] )
        report.charts.should eql( [] )
      end

    end

  end

end
