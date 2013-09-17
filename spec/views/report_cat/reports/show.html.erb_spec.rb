require 'spec_helper'

describe 'report_cat/reports/show.html.erb' do

  include SetupReports

  before( :each ) do
    setup_reports
  end

  it 'renders without exception' do
    assign( :reports, @reports )
    assign( :report, @report )
    render
  end

end