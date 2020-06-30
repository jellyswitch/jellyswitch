# typed: false
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  context "for an admin" do
    let(:subdomain) { create(:subdomain) }
    let(:operator) { create(:operator, :with_location, :with_individual_plans, subdomain: subdomain.subdomain) }
    let(:admin) { create(:user, :admin) }

    before do
      ActsAsTenant.default_tenant = operator
      admin.update(operator_id: operator.id)
    end

    after do
      ActsAsTenant.default_tenant = nil
    end

    it "redirects to landing path with a correct password" do
      post login_path, params: { session: { email: admin.email, password: 'password' } }
      expect(response).to redirect_to(landing_path)
    end

    it "re-renders the login page with an incorrect password" do
      post login_path, params: { session: { email: admin.email, password: 'wrongpassword' } }
      expect(response).to render_template(:new)
    end
  end

  context "for a superadmin"
  context "for a member"
end