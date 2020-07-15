include ReportCat::Core

module ReportCat::Core

  describe Param do

    let( :param ) { Param.new }

    before( :each ) do
      @name = :test
      @type = :select
      @value = 727
      @options = [ 314, 727 ]
    end

    describe 'initialize' do

      it 'initializes accessor values' do
        param = Param.new( :name => @name, :type => @type, :value => @value, :options => @options )
        expect( param.name ).to eql( @name )
        expect( param.type ).to eql( @type )
        expect( param.value ).to eql( @value )
        expect( param.options ).to eql( @options )
      end

      it 'initializes options to an empty hash' do
        expect( param.options ).to eql( {} )
      end
    end

    describe 'assigning value' do

      it 'turns checkboxes into booleans' do
        param = Param.new( :name => :foo, :type => :check_box )
        expect( param.value ).to be_nil
        param.value = '1'
        expect( param.value ).to be( true )
        param.value = '0'
        expect( param.value ).to be( false )
      end

      it 'accepts checkboxes as booleans' do
        param = Param.new( :name => :foo, :type => :check_box )
        expect( param.value ).to be_nil
        param.value = true
        expect( param.value ).to be( true )
        param.value = false
        expect( param.value ).to be( false )
      end

      it 'accepts checkboxes as strings' do
        param = Param.new( :name => :foo, :type => :check_box )
        expect( param.value ).to be_nil
        param.value = 'true'
        expect( param.value ).to be( true )
        param.value = 'false'
        expect( param.value ).to be( false )
      end

      it 'parses date hashes' do
        param = Param.new( :name => :foo, :type => :date )
        param.value = { :year => '2013', :month => '9', :day => '16' }
        expect( param.value ).to eql( Date.civil( 2013, 9, 16 ) )
      end

      it 'parses date strings' do
        param = Param.new( :name => :foo, :type => :date )
        param.value = '2013-09-16'
        expect( param.value ).to eql( Date.civil( 2013, 9, 16 ) )
      end

      it 'passes everything else through untouched' do
        param = Param.new( :name => :foo, :type => :text_field )
        param.value = '2013-09-16'
        expect( param.value ).to eql( '2013-09-16' )
      end
    end

    describe '#hide' do

      it 'sets the hidden option to true' do
        expect( param.options[ :hidden ] ).to be_nil
        param.hide
        expect( param.options[ :hidden ] ).to be( true )
      end
    end
  end
end
