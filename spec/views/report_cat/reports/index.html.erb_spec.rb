describe 'report_cat/reports/index.html.erb' do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  it 'renders without exception' do
    assign( :reports, @reports )
    render
  end
end