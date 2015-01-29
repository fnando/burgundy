require 'spec_helper'

describe Burgundy do
  let(:wrapper) { Class.new(Burgundy::Item) }

  it 'delegates everything' do
    item = wrapper.new('hello')
    expect(item.upcase).to eql('HELLO')
  end

  it 'wraps items' do
    items = wrapper.wrap([1,2,3])

    expect(items.class).to eql(Burgundy::Collection)
    expect(items.first).to be_a(wrapper)
    expect(items.first.to_i).to eql(1)
  end

  it 'deprecates Burgundy::Item.map' do
    message = 'Burgundy::Item.map is deprecated; use Burgundy::Item.wrap instead.'
    expect(wrapper).to receive(:warn).with(message)
    wrapper.map([1,2,3])
  end

  it 'wraps items in collection' do
    collection = Burgundy::Collection.new([1,2,3], wrapper)
    expect(collection.first).to eql(1)
  end

  it 'delegates collection calls' do
    collection = Burgundy::Collection.new([1,2,3], wrapper)
    expect(collection.size).to eql(3)
  end

  it 'includes Enumerable' do
    expect(Burgundy::Collection).to include(Enumerable)
  end

  it 'implements #empty?' do
    collection = Burgundy::Collection.new([1,2,3])
    expect(collection).not_to be_empty

    collection = Burgundy::Collection.new([])
    expect(collection).to be_empty
  end

  it 'responds to the routes method' do
    item = wrapper.new('hello')

    expect(item).to respond_to(:routes)
    expect(item).to respond_to(:r)
  end

  it 'responds to the helpers method' do
    item = wrapper.new('hello')

    expect(item).to respond_to(:helpers)
    expect(item).to respond_to(:h)
  end

  it 'responds to the I18n methods' do
    item = wrapper.new('hello')

    expect(item).to respond_to(:translate)
    expect(item).to respond_to(:t)
    expect(item).to respond_to(:localize)
    expect(item).to respond_to(:l)
  end

  it 'returns route using action mailer options' do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.configuration.action_mailer.default_url_options = {host: 'example.org'}
    item = wrapper.new OpenStruct.new(username: 'johndoe')

    expect(item.profile_url).to eql('http://example.org/johndoe')
  end

  it 'returns route using action controller options' do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.application.routes.default_url_options = {host: 'example.org'}
    item = wrapper.new OpenStruct.new(username: 'johndoe')

    expect(item.profile_url).to eql('http://example.org/johndoe')
  end
end
