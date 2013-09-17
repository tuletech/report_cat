require 'spec_helper'

describe ReportCat::ReportsController do

  include SetupReports

  routes { ReportCat::Engine.routes }

  before( :each ) do
    setup_reports
    controller.stub( :get_reports ).and_return( @reports )
  end

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end

  describe '/index' do

    it 'gets successfully' do
      get :index
      response.should be_success
    end

    it 'assigns reports' do
      get :index
      assigns( :reports ).should be_an_instance_of( HashWithIndifferentAccess )
    end

  end

  describe '/show' do

    before( :each ) do
      @report.stub( :query )
    end

    it 'gets successfully' do
      get :show, :id => @report.name
      response.should be_success
    end

    it 'assigns report' do
      get :show, :id => @report.name
      assigns( :report ).should be_an_instance_of( Report )
    end
  end

end