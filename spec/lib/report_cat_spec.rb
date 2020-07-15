include ReportCat

describe ReportCat do

  it 'requires the engine' do
    expect( ReportCat::Engine ).to_not be_nil
  end

  it 'defines the ReportCat module' do
    expect( ReportCat ).to_not be_nil
  end

  #############################################################################
  # config

  describe '::config' do

    it 'returns the configuration' do
      expect( ReportCat.config ).to be_an_instance_of( ReportCat::Config )
    end
  end

  #############################################################################
  # configure

  describe '::configure' do

    it 'yields the configuration' do
      yielded = false
      ReportCat.configure do |config|
        expect( config ).to be_an_instance_of( ReportCat::Config )
        yielded = true
      end
      expect( yielded ).to be( true )
    end
  end

  #############################################################################
  # reports

  describe '::reports' do

    it 'returns a HashWithIndifferentAccess' do
      expect( ReportCat.reports ).to be_an_instance_of( HashWithIndifferentAccess )
    end

    it 'adds Report subclasses to the hash' do
      reports = ReportCat.reports

      Report.descendants.each do |klass|
        report = klass.new
        expect( reports[ report.name.to_sym ] ).to_not be_nil
      end
    end
  end
end