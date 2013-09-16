require 'spec_helper'

describe ReportCat::ReportsController do

  routes { ReportCat::Engine.routes }

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end

  describe '/index' do

    it 'gets successfully' do
      get :index
      response.should be_success
    end

  end

end