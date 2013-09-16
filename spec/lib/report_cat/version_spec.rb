require 'spec_helper'

describe 'version' do

  it 'has a version constant' do
    ReportCat::VERSION.should_not be_nil
    ReportCat::VERSION.should be_an_instance_of( String )
    ReportCat::VERSION.should =~ /\d+\.\d+\.\d+/
  end

end