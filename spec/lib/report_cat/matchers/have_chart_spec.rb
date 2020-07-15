include ReportCat::Core

describe RSpec::Matchers, 'have_chart' do

  let( :name ) { :test }
  let( :type ) { :integer }
  let( :label ) { :label }
  let( :values ) { [] }
  let( :options ) { { :foo => true } }

  before( :each ) do
    @report = Report.new
    @chart = @report.add_chart( name, type, label, values, options )
  end

  it 'passes if the report has the chart' do
    expect( @report ).to have_chart( name )
    expect( @report ).to have_chart( name ).with_type( type )
    expect( @report ).to have_chart( name ).with_label( label )
    expect( @report ).to have_chart( name ).with_values( values )
    expect( @report ).to have_chart( name ).with_options( options )
    expect( @report ).to have_chart( name ).with_type( type ).with_label( label ).with_values( values ).with_options( options )
  end

  it 'fails if the report does not have the chart' do
    expect( @report ).to_not have_chart( :foo )
    expect( @report ).to_not have_chart( name ).with_type( :foo )
    expect( @report ).to_not have_chart( name ).with_label( :foo )
    expect( @report ).to_not have_chart( name ).with_values( :foo )
    expect( @report ).to_not have_chart( name ).with_options( :foo )
    expect( @report ).to_not have_chart( name ).with_type( :foo ).with_label( :foo ).with_values( :foo ).with_options( :foo )
  end
end