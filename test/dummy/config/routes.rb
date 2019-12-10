# frozen_string_literal: true

Dummy::Application.routes.draw do
  get ":username", to: "application#users", as: "profile"
end
