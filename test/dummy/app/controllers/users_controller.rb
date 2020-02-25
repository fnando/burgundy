# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    presenter = Class.new(Burgundy::Item) do
      def to_partial_path
        "users/profile"
      end
    end

    @users = presenter.wrap([
      OpenStruct.new(name: "John"),
      OpenStruct.new(name: "Mary")
    ])
  end
end
