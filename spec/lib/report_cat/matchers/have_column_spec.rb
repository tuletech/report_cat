require 'spec_helper'

include ReportCat::Core

describe RSpec::Matchers, 'have_column' do

  let( :name ) { :test }
  let( :type ) { :integer }

  before( :each ) do
    @report = Report.new
    @column = @report.add_column( name, type )
  end

  it 'passes if the report has the column' do
    expect( @report ).to have_column( name )
  end

  it 'passes if the report has the column and type' do
    expect( @report ).to have_column( name ).with_type( type )
  end

  it 'fails when type is wrong' do
    expect( @report ).to_not have_column( name ).with_type( :foo )
  end

  it 'fails when the column is not there' do
    expect( @report ).to_not have_column( :foo )
  end

end