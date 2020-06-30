# typed: false
require 'rails_helper'

RSpec.describe 'Landing', type: :request do
  context "on a single location operator" do
    let(:subdomain) { create(:subdomain) }
    let(:operator) { create(:operator, :with_location, :with_individual_plans, subdomain: subdomain.subdomain) }

    before do
      ActsAsTenant.default_tenant = operator
    end

    after do
      ActsAsTenant.default_tenant = nil
    end

    it "renders the home screen on root" do
      get "/"
      expect(response).to render_template(:index)
      expect(response).to render_template("operator/landing/_snippet")
    end
  end

  context "on a multiple locations operator" do
    let(:subdomain) { create(:subdomain) }
    let(:operator) { create(:operator, :with_multiple_locations, :with_individual_plans, subdomain: subdomain.subdomain) }

    before do
      ActsAsTenant.default_tenant = operator
    end

    after do
      ActsAsTenant.default_tenant = nil
    end

    it "renders the home screen on root" do
      get "/"
      expect(response).to render_template(:index)
      expect(response).to render_template("operator/locations/_location")
    end
  end
end