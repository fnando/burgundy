# frozen_string_literal: true

require "test_helper"

class BurgundyTest < Minitest::Test
  let(:wrapper) { Class.new(Burgundy::Item) }
  let(:wrapper_with_args) { ItemWithAdditionalArgs }

  test "delegates everything" do
    item = wrapper.new("hello")
    assert_equal "HELLO", item.upcase
  end

  test "wraps items" do
    items = wrapper.wrap([1, 2, 3])

    assert_equal Burgundy::Collection, items.class
    assert_kind_of wrapper, items.first
    assert_equal 1, items.first.to_i
  end

  test "wraps items with additional arguments" do
    items = wrapper_with_args.wrap([1], 2, 3)

    assert_equal Burgundy::Collection, items.class
    assert_kind_of wrapper_with_args, items.first
    assert_equal 1, items.first.item
    assert_equal [2, 3], items.first.args
  end

  test "deprecates Burgundy::Item.map" do
    message =
      "Burgundy::Item.map is deprecated; use Burgundy::Item.wrap instead."

    _, err = capture_io do
      wrapper.map([1, 2, 3])
    end

    assert err.include?(message)
  end

  test "wraps items in collection" do
    collection = Burgundy::Collection.new([1, 2, 3], wrapper)
    assert_equal 1, collection.first
  end

  test "delegates collection calls" do
    collection = Burgundy::Collection.new([1, 2, 3], wrapper)
    assert_equal 3, collection.size
  end

  test "collection uses to_a result when have no wrapper class" do
    items = Class.new do
      def to_a
        [1, 2, 3]
      end
    end.new

    collection = Burgundy::Collection.new(items)

    assert_equal [1, 2, 3], collection.to_ary
  end

  test "implements #empty?" do
    collection = Burgundy::Collection.new([1, 2, 3])
    refute collection.empty?

    collection = Burgundy::Collection.new([])
    assert collection.empty?
  end

  test "responds to the routes method" do
    item = wrapper.new("hello")

    assert_respond_to item, :routes
    assert_respond_to item, :r
  end

  test "responds to the helpers method" do
    item = wrapper.new("hello")

    assert_respond_to item, :helpers
    assert_respond_to item, :h
  end

  test "makes helpers accessible" do
    item = wrapper.new("hello")

    assert_equal "less than a minute", item.helpers.time_ago_in_words(Time.now)
  end

  test "responds to the I18n methods" do
    item = wrapper.new("hello")

    assert_respond_to item, :translate
    assert_respond_to item, :t
    assert_respond_to item, :localize
    assert_respond_to item, :l
  end

  test "returns route using action mailer options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url
        routes.profile_url(username)
      end
    end

    Rails
      .configuration
      .action_mailer
      .default_url_options = {host: "example.com"}

    item = wrapper.new OpenStruct.new(username: "johndoe")

    assert_equal "http://example.com/johndoe", item.profile_url
  end

  test "returns route using action controller options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url
        routes.profile_url(username)
      end
    end

    Rails.application.routes.default_url_options = {host: "example.com"}
    item = wrapper.new OpenStruct.new(username: "johndoe")

    assert_equal "http://example.com/johndoe", item.profile_url
  end

  test "returns to_param" do
    klass = Class.new do
      def to_param
        "some-param"
      end
    end

    wrapper = Class.new(Burgundy::Item)
    item = wrapper.new(klass.new)

    assert_equal "some-param", item.to_param
  end

  test "returns attributes" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(
      name: "John Doe",
      email: "john@example.com",
      username: "johndoe"
    )
    item = wrapper.new(object)

    expected = {name: "John Doe", email: "john@example.com"}

    assert_equal expected, item.attributes
  end

  test "returns remaps attribute" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, username: :login
    end

    object = OpenStruct.new(name: "John Doe", username: "johndoe")
    item = wrapper.new(object)

    expected = {name: "John Doe", login: "johndoe"}

    assert_equal expected, item.attributes
  end

  test "implements to_hash/to_h/as_json protocols" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(
      name: "John Doe",
      email: "john@example.com",
      username: "johndoe"
    )
    item = wrapper.new(object)

    assert_equal item.to_hash, item.attributes
    assert_equal item.to_h, item.attributes
    assert_equal item.as_json, item.attributes
    assert_equal item.as_json(:name), item.attributes
  end

  test "implements to_json protocol" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name
    end

    object = OpenStruct.new(
      name: "John Doe",
      email: "john@example.com",
      username: "johndoe"
    )
    item = wrapper.new(object)

    assert_equal %[{"name":"John Doe"}], item.to_json
  end

  test "inherits attributes" do
    parent_wrapper = Class.new(Burgundy::Item) do
      attributes :name, :username
    end

    wrapper = Class.new(parent_wrapper)
    object = OpenStruct.new(name: "John Doe", username: "johndoe")
    item = wrapper.new(object)

    expected = {name: "John Doe", username: "johndoe"}

    assert_equal expected, item.attributes
  end

  test "always wrap items fetched from collection" do
    wrapper = Class.new(Burgundy::Item)
    collection = wrapper.wrap([1])

    assert_kind_of wrapper, collection[0]
    assert_kind_of wrapper, collection.fetch(0)
    assert_kind_of wrapper, collection.at(0)
  end

  test "responds to methods present on the underying wrapped object" do
    wrapper = Class.new(Burgundy::Item)
    collection = wrapper.wrap([1])

    assert collection.respond_to?(:first)
    refute collection.respond_to?(:missing)
  end
end
