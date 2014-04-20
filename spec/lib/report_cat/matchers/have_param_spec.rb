require 'spec_helper'

include ReportCat::Core

describe RSpec::Matchers, 'have_param' do

  let( :name ) { :test }
  let( :type ) { :integer }

  before( :each ) do
    @report = Report.new
    @param = @report.add_param( name, type )
  end

  it 'passes if the report has the param' do
    expect( @report ).to have_param( name )
  end

  it 'passes if the report has the param and type' do
    expect( @report ).to have_param( name ).with_type( type )
  end

  it 'fails when type is wrong' do
    expect( @report ).to_not have_param( name ).with_type( :foo )
  end

  it 'fails when the param is not there' do
    expect( @report ).to_not have_param( :foo )
  end

end