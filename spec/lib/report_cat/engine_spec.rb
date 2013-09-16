require 'spec_helper'

describe ReportCat::Engine do

  it 'isolates the ReportCat namespace' do
    ReportCat::Engine.isolated.should be_true
  end

end