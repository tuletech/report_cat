require 'spec_helper'

describe 'version' do

  it 'has a version constant' do
    expect( ReportCat::VERSION ).to_not be_nil
    expect( ReportCat::VERSION ).to be_an_instance_of( String )
    expect( ReportCat::VERSION ).to match( /\d+\.\d+\.\d+/ )
  end

end