# frozen_string_literal: true

require "test_helper"

class BurgundyTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Rails.application
  end

  test "renders collection with custom partial path" do
    get "/users"
    html = Nokogiri(last_response.body)
    h1s = html.css("h1")

    assert_equal 2, h1s.size
    assert_equal "John", h1s[0].text
    assert_equal "Mary", h1s[1].text
  end

  test "wrapped object is the same as the unwrapped object" do
    model = Class.new do
      include ActiveModel::Model
      attr_accessor :name
    end

    presenter = Class.new(Burgundy::Item)
    instance = model.new(name: "John")

    assert presenter.new(instance).eql?(instance)
  end
end
