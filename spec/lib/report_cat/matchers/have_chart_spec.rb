require 'spec_helper'

include ReportCat::Core

describe RSpec::Matchers, 'have_chart' do

  let( :name ) { :test }
  let( :type ) { :integer }
  let( :label ) { :label }
  let( :values ) { [] }

  before( :each ) do
    @report = Report.new
    @chart = @report.add_chart( name, type, label, values )
  end

  it 'passes if the report has the chart' do
    expect( @report ).to have_chart( name )
  end

  it 'passes if the report has the chart and type' do
    expect( @report ).to have_chart( name ).with_type( type )
  end

  it 'fails when type is wrong' do
    expect( @report ).to_not have_chart( name ).with_type( :foo )
  end

  it 'fails when the chart is not there' do
    expect( @report ).to_not have_chart( :foo )
  end

end