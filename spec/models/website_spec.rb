require 'spec_helper'

describe Website do
  context "validation" do
    let(:website) { Website.new(name: "test", url: "http://example.com") }
    it "checks name presence" do
      website.name = nil
      website.should_not be_valid
      website.errors[:name].should include("can't be blank")
    end

    it "checks url presence" do
      website.url = nil
      website.should_not be_valid
      website.errors[:url].should include("can't be blank")
    end

    it "checks url if it's HTTP/S" do
      website.url = "ftp://example.com"
      website.should_not be_valid
      website.errors[:url].should include("can only be HTTP or HTTPS")
      website.url = "https://twitter.com"
      website.should be_valid
    end

    it "checks url if it's reachable" do
      website.url = "http://example.dev"
      website.should_not be_valid
      website.errors[:url].should include("can't be reached")
    end
  end

  context "checking" do
    let(:website) { Website.create(name: "test", url: "http://example.com") }

    it "finds out the status of the website" do
      website.check
      website.reload
      website.status_code.should == 200
      website.status_message.should == "OK"
      website.checked_at.should_not be_nil
    end
  end

  context "status container class" do
    let(:website) { Website.new }

    it "should be unknown on nil" do
      website.container_class.should == "unknown"
    end

    it "should be ok on 200" do
      website.status_code = 200
      website.container_class.should == "ok"
    end

    it "should be redirect on 302" do
      website.status_code = 302
      website.container_class.should == "redirect"
    end

    it "should be error on 404" do
      website.status_code = 404
      website.container_class.should == "error"
    end

    it "should be error on 500" do
      website.status_code = 500
      website.container_class.should == "error"
    end
  end
end
