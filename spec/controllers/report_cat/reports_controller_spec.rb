require 'spec_helper'

describe ReportCat::ReportsController do

  include SetupReports

  routes { ReportCat::Engine.routes }

  before( :each ) do
    setup_reports
  end

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end

  #############################################################################
  # index

  describe '#index' do

    it 'gets successfully' do
      get :index
      response.should be_success
    end

    it 'assigns reports' do
      get :index
      assigns( :reports ).should be_an_instance_of( HashWithIndifferentAccess )
    end

    it 'uses the configured before authentication filter' do
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
      @report.stub( :query )
      ReportCat.stub( :reports ).and_return( @reports )
    end

    it 'gets successfully' do
      get :show, :id => @report.name
      response.should be_success
    end

    it 'assigns report' do
      get :show, :id => @report.name
      assigns( :report ).should be_an_instance_of( Report )
    end

    context 'formatting CSV' do

      it 'renders CSV' do
        get :show, :id => @report.name, :format => 'csv'
        response.should be_success
        response.content_type.should eql( 'text/csv' )
      end

   end

    context 'formatting HTML' do

      it 'renders HTML' do
        get :show, :id => @report.name, :format => 'html'
        response.should be_success
        response.content_type.should eql( 'text/html' )
      end

    end

  end

  #############################################################################
  # set_reports

  describe '#set_reports' do

    it 'memoizes get_reports in @reports' do
      expect( ReportCat ).to receive( :reports ).and_return( @reports )
      controller.send( :set_reports )
      assigns( :reports ).should eql( @reports )
    end

  end

end