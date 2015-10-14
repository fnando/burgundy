require 'spec_helper'

describe Burgundy do
  let(:wrapper) { Class.new(Burgundy::Item) }
  let(:wrapper_with_args) { ItemWithAdditionalArgs }

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

  it 'wraps items with additional arguments' do
    items = wrapper_with_args.wrap([1], 2, 3)

    expect(items.class).to eql(Burgundy::Collection)
    expect(items.first).to be_a(wrapper_with_args)
    expect(items.first.item).to eql(1)
    expect(items.first.args).to eql([2, 3])
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

  it 'wraps items with additional arguments' do
    collection = Burgundy::Collection.new([1], wrapper_with_args, 2, 3)

    expect(collection.first.item).to eq(1)
    expect(collection.first.args).to eq([2, 3])
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

  it 'returns attributes' do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(name: 'John Doe', email: 'john@example.org', username: 'johndoe')
    item = wrapper.new(object)

    expect(item.attributes).to eq(name: 'John Doe', email: 'john@example.org')
  end

  it 'returns remaps attribute' do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :username => :login
    end

    object = OpenStruct.new(name: 'John Doe', username: 'johndoe')
    item = wrapper.new(object)

    expect(item.attributes).to eq(name: 'John Doe', login: 'johndoe')
  end

  it 'implements to_hash/to_h protocol' do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(name: 'John Doe', email: 'john@example.org', username: 'johndoe')
    item = wrapper.new(object)

    expect(item.attributes).to eq(item.to_hash)
    expect(item.attributes).to eq(item.to_h)
  end

  it 'inherits attributes' do
    parent_wrapper = Class.new(Burgundy::Item) do
      attributes :name, :username
    end

    wrapper = Class.new(parent_wrapper)
    object = OpenStruct.new(name: 'John Doe', username: 'johndoe')
    item = wrapper.new(object)

    expect(item.attributes).to eq(name: 'John Doe', username: 'johndoe')
  end
end
