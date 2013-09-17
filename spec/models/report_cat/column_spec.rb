require 'spec_helper'

module ReportCat

  describe Column do

    before( :each ) do
      @name = :test
      @type = :select
      @sql = 'max( something )'
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        column = ReportCat::Column.new( :name => @name, :type => @type, :sql => @sql )
        column.name.should eql( @name )
        column.type.should eql( @type )
        column.sql.should eql( @sql )
      end

    end

  end

end
