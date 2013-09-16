require 'spec_helper'

include ReportCat

describe ReportCat do

  it 'requires the engine' do
    ReportCat::Engine.should_not be_nil
  end

  it 'defines the ReportCat module' do
    ReportCat.should_not be_nil
  end

end