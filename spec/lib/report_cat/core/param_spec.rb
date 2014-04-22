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

    describe 'assigning value' do

      it 'turns checkboxes into booleans' do
        param = Param.new( :name => :foo, :type => :check_box )
        param.value.should be_nil
        param.value = '1'
        param.value.should be_true
        param.value = '0'
        param.value.should be_false
      end

      it 'accepts checkboxes as booleans' do
        param = Param.new( :name => :foo, :type => :check_box )
        param.value.should be_nil
        param.value = true
        param.value.should be_true
        param.value = false
        param.value.should be_false
      end

      it 'accepts checkboxes as strings' do
        param = Param.new( :name => :foo, :type => :check_box )
        param.value.should be_nil
        param.value = 'true'
        param.value.should be_true
        param.value = 'false'
        param.value.should be_false
      end

      it 'parses date hashes' do
        param = Param.new( :name => :foo, :type => :date )
        param.value = { :year => '2013', :month => '9', :day => '16' }
        param.value.should eql( Date.civil( 2013, 9, 16 ) )
      end

      it 'parses date strings' do
        param = Param.new( :name => :foo, :type => :date )
        param.value = '2013-09-16'
        param.value.should eql( Date.civil( 2013, 9, 16 ) )
      end

      it 'passes everything else through untouched' do
        param = Param.new( :name => :foo, :type => :text_field )
        param.value = '2013-09-16'
        param.value.should eql( '2013-09-16' )
      end

    end

  end

end
