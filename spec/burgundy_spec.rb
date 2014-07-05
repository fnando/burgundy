require "spec_helper"

describe Burgundy do
  let(:wrapper) { Class.new(Burgundy::Item) }

  it "delegates everything" do
    item = wrapper.new("hello")
    expect(item.upcase).to eql("HELLO")
  end

  it "wraps items" do
    items = wrapper.map([1,2,3])

    expect(items.first).to be_a(wrapper)
    expect(items.first.to_i).to eql(1)
  end

  it "wraps items in collection" do
    collection = Burgundy::Collection.new([1,2,3], wrapper)
    expect(collection.first).to eql(1)
  end

  it "includes Enumerable" do
    expect(Burgundy::Collection).to include(Enumerable)
  end

  it 'implements #empty?' do
    collection = Burgundy::Collection.new([1,2,3])
    expect(collection).not_to be_empty

    collection = Burgundy::Collection.new([])
    expect(collection).to be_empty
  end

  it "responds to the routes method" do
    item = wrapper.new("hello")

    expect(item.respond_to?(:routes, true)).to be
    expect(item.respond_to?(:r, true)).to be
  end

  it "responds to the helpers method" do
    item = wrapper.new("hello")

    expect(item.respond_to?(:helpers, true)).to be
    expect(item.respond_to?(:h, true)).to be
  end

  it "responds to the I18n methods" do
    item = wrapper.new("hello")

    expect(item.respond_to?(:translate, true)).to be
    expect(item.respond_to?(:t, true)).to be
    expect(item.respond_to?(:localize, true)).to be
    expect(item.respond_to?(:l, true)).to be
  end

  it "returns route using action mailer options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.configuration.action_mailer.default_url_options = {host: "example.org"}
    item = wrapper.new OpenStruct.new(username: "johndoe")

    expect(item.profile_url).to eql("http://example.org/johndoe")
  end

  it "returns route using action controller options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.application.routes.default_url_options = {host: "example.org"}
    item = wrapper.new OpenStruct.new(username: "johndoe")

    expect(item.profile_url).to eql("http://example.org/johndoe")
  end
end
