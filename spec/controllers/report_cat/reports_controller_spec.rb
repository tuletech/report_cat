describe ReportCat::ReportsController do

  include SetupReports

  routes { ReportCat::Engine.routes }

  before( :each ) do
    setup_reports
  end

  it 'is a subclass of ApplicationController' do
    expect( @controller ).to be_a_kind_of( ApplicationController )
  end

  #############################################################################
  # index

  describe '#index' do

    it 'gets successfully' do
      get :index
      expect( response ).to be_success
    end

    it 'assigns reports' do
      get :index
      expect( assigns( :reports ) ).to be_an_instance_of( HashWithIndifferentAccess )
    end

    pending 'uses the configured before authentication filter' do
      expect( @controller ).to receive( :instance_eval ).with( &ReportCat.config.authenticate_with )
      expect( @controller ).to receive( :instance_eval ).with( &ReportCat.config.authorize_with )
      get :index
    end

    it 'renders with the configured layout' do
      get :index
      expect( response ).to render_template( ReportCat.config.layout )
    end
  end

  #############################################################################
  # show

  describe '#show' do

    before( :each ) do
      allow( @report ).to receive( :query )
      allow( ReportCat ).to receive( :reports ).and_return( @reports )
    end

    it 'gets successfully' do
      get :show, params: { :id => @report.name }
      expect( response ).to be_success
    end

    it 'assigns report' do
      get :show, params: { :id => @report.name }
      expect( assigns( :report ) ).to be_an_instance_of( Report )
    end

    context 'formatting CSV' do

      it 'renders CSV' do
        get :show, params: { :id => @report.name, :format => 'csv' }
        expect( response ).to be_success
        expect( response.content_type ).to eql( 'text/csv' )
      end
   end

    context 'formatting HTML' do

      it 'renders HTML' do
        get :show, params: { :id => @report.name, :format => 'html' }
        expect( response ).to be_success
        expect( response.content_type ).to eql( 'text/html' )
      end
    end
  end

  #############################################################################
  # set_reports

  describe '#set_reports' do

    it 'memoizes get_reports in @reports' do
      expect( ReportCat ).to receive( :reports ).and_return( @reports )
      controller.send( :set_reports )
      expect( assigns( :reports ) ).to eql( @reports )
    end
  end
end