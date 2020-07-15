describe ReportCat::Config do

  let( :config ) { ReportCat::Config.instance }

  it 'is a singleton' do
    expect( config ).to be( ReportCat::Config.instance )
  end

  describe 'attributes' do

    it 'has an #authenticate accessor' do
      config.authenticate = ReportCat::Config::NIL_PROC
      config.authenticate = config.authenticate
      expect( config.authenticate ).to eql( config.authenticate )
    end

    it 'has an #authorize accessor' do
      config.authorize = ReportCat::Config::NIL_PROC
      config.authorize = config.authorize
      expect( config.authorize ).to eql( config.authorize )
    end

    it 'has an #layout excludes' do
      expect( config.excludes ).to_not be_nil
      config.excludes = config.excludes
      expect( config.excludes ).to eql( config.excludes )
    end

    it 'has a #layout accessor' do
      expect( config.layout ).to_not be_nil
      config.layout = config.layout
      expect( config.layout ).to eql( config.layout )
    end
  end

  describe '#authenticate_with' do

    it 'accepts a block' do
      config.authenticate = nil
      config.authenticate_with do
        true
      end

      expect( config.authenticate ).to_not be_nil
    end

    it 'returns a block' do
      @test = false
      config.authenticate_with do
        @test = true
      end

      instance_eval( &config.authenticate_with )
      expect( @test ).to be( true )
    end

    it 'returns a nil proc if none has been set' do
      config.authenticate = nil
      instance_eval( &config.authenticate_with )
    end
  end

  describe '#authorize_with' do

    it 'accepts a block' do
      config.authorize = nil
      config.authorize_with do
        true
      end

      expect( config.authorize ).to_not be_nil
    end

    it 'returns a block' do
      @test = false
      config.authorize_with do
        @test = true
      end

      instance_eval( &config.authorize_with )
      expect( @test ).to be( true )
    end

    it 'returns a nil proc if none has been set' do
      config.authorize = nil
      instance_eval( &config.authorize_with )
    end
  end
end

