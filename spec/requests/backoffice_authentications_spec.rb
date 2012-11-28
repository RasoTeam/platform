require 'spec_helper'

describe "BackofficeAuthentications" do
  describe "GET /backoffice_authentications" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get backoffice_authentications_path
      response.status.should be(200)
    end
  end
end
