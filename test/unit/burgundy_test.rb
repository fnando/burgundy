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
    message = "Burgundy::Item.map is deprecated; use Burgundy::Item.wrap instead."

    out, err = capture_io do
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

  test "includes Enumerable" do
    assert Burgundy::Collection.included_modules.include?(Enumerable)
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

  test "responds to the I18n methods" do
    item = wrapper.new("hello")

    assert_respond_to item, :translate
    assert_respond_to item, :t
    assert_respond_to item, :localize
    assert_respond_to item, :l
  end

  test "returns route using action mailer options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.configuration.action_mailer.default_url_options = {host: "example.org"}
    item = wrapper.new OpenStruct.new(username: "johndoe")

    assert_equal "http://example.org/johndoe", item.profile_url
  end

  test "returns route using action controller options" do
    wrapper = Class.new(Burgundy::Item) do
      def profile_url; routes.profile_url(username) end
    end

    Rails.application.routes.default_url_options = {host: "example.org"}
    item = wrapper.new OpenStruct.new(username: "johndoe")

    assert_equal "http://example.org/johndoe", item.profile_url
  end

  test "returns attributes" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(name: "John Doe", email: "john@example.org", username: "johndoe")
    item = wrapper.new(object)

    expected = {name: "John Doe", email: "john@example.org"}

    assert_equal expected, item.attributes
  end

  test "returns remaps attribute" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :username => :login
    end

    object = OpenStruct.new(name: "John Doe", username: "johndoe")
    item = wrapper.new(object)

    expected = {name: "John Doe", login: "johndoe"}

    assert_equal expected, item.attributes
  end

  test "implements to_hash/to_h protocol" do
    wrapper = Class.new(Burgundy::Item) do
      attributes :name, :email
    end

    object = OpenStruct.new(name: "John Doe", email: "john@example.org", username: "johndoe")
    item = wrapper.new(object)

    assert_equal item.to_hash, item.attributes
    assert_equal item.to_h, item.attributes
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
end
