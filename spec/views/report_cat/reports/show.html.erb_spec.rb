require 'spec_helper'

describe 'report_cat/reports/show.html.erb' do

  include SetupReports

  before( :each ) do
    setup_reports
    allow( view ).to receive( :report_path ).and_return( '/report_cat/reports/foo' )
    allow( view ).to receive( :reports_path ).and_return( '/report_cat' )
  end

  it 'renders without exception' do
    assign( :reports, @reports )
    assign( :report, @report )
    render
  end

end