require 'spec_helper'

include ReportCat::Core

describe RSpec::Matchers, 'have_column' do

  let( :name ) { :test }
  let( :type ) { :integer }
  let( :options ) { { :foo => true } }

  before( :each ) do
    @report = Report.new
    @column = @report.add_column( name, type, options  )
  end

  it 'passes if the report has the column' do
    expect( @report ).to have_column( name )
    expect( @report ).to have_column( name ).with_type( type )
    expect( @report ).to have_column( name ).with_options( options )
    expect( @report ).to have_column( name ).with_type( type ).with_options( options )
  end

  it 'fails if the report does not have the column' do
    expect( @report ).to_not have_column( :foo )
    expect( @report ).to_not have_column( name ).with_type( :foo )
    expect( @report ).to_not have_column( name ).with_options( :foo )
    expect( @report ).to_not have_column( name ).with_type( :foo ).with_options( :foo )
  end

end