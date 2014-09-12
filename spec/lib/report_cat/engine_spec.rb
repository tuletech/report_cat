require 'spec_helper'

describe ReportCat::Engine do

  it 'isolates the ReportCat namespace' do
    expect( ReportCat::Engine.isolated ).to be( true )
  end

end