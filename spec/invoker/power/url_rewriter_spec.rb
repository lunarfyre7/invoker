require 'spec_helper'

describe Invoker::Power::UrlRewriter do
  let(:rewriter) { Invoker::Power::UrlRewriter.new }

  context "matching domain part of incoming request" do
    before(:all) do
      @original_invoker_config = Invoker.config

      Invoker.config = mock
      Invoker.config.stubs(:tld).returns("test")
    end

    after(:all) do
      Invoker.config = @original_invoker_config
    end

    it "should match foo.test" do
      match = rewriter.extract_host_from_domain("foo.test")
      expect(match).to_not be_empty

      matching_string = match[0]
      expect(matching_string).to eq("foo")
    end

    it "should match foo.test:1080" do
      match = rewriter.extract_host_from_domain("foo.test:1080")
      expect(match).to_not be_empty

      matching_string = match[0]
      expect(matching_string).to eq("foo")
    end

    it "should match emacs.bar.test" do
      match = rewriter.extract_host_from_domain("emacs.bar.test")
      expect(match).to_not be_empty

      expect(match[0]).to eq("emacs.bar")
      expect(match[1]).to eq("bar")
    end

    it "should match hello-world.test" do
      match = rewriter.extract_host_from_domain("hello-world.test")
      expect(match).to_not be_nil

      expect(match[0]).to eq("hello-world")
    end

    context 'user sets up a custom top level domain' do
      before(:all) do
        @original_invoker_config = Invoker.config

        Invoker.config = mock
        Invoker.config.stubs(:tld).returns("local")
      end

      it 'should match domain part of incoming request correctly' do
        match = rewriter.extract_host_from_domain("foo.local")
        expect(match).to_not be_empty

        matching_string = match[0]
        expect(matching_string).to eq("foo")
      end

      after(:all) do
        Invoker.config = @original_invoker_config
      end
    end
  end
end
