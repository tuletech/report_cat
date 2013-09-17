require 'spec_helper'

include ReportCat

describe 'report_cat/reports/index.html.erb' do

  it 'renders without exception' do
    assign( :reports, [ :bar, :foo ] )
    render
  end

end