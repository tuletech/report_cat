require 'spec_helper'

include ReportCat::Core

describe RSpec::Matchers, 'have_param' do

  let( :name ) { :test }
  let( :type ) { :select }
  let( :value ) { :value }
  let( :options ) { [ :foo, :bar ] }

  before( :each ) do
    @report = Report.new
    @param = @report.add_param( name, type, value, options )
  end

  it 'passes if the report has the param' do
    expect( @report ).to have_param( name )
    expect( @report ).to have_param( name ).with_type( type )
    expect( @report ).to have_param( name ).with_value( value )
    expect( @report ).to have_param( name ).with_options( options )
    expect( @report ).to have_param( name ).with_type( type ).with_value( value ).with_options( options )
  end

  it 'fails if the report does not have the param' do
    expect( @report ).to_not have_param( :foo )
    expect( @report ).to_not have_param( name ).with_type( :foo )
    expect( @report ).to_not have_param( name ).with_value( :foo )
    expect( @report ).to_not have_param( name ).with_options( :foo )
    expect( @report ).to_not have_param( name ).with_type( :foo ).with_value( :foo ).with_options( :foo )
  end

end