# frozen_string_literal: true

Dummy::Application.routes.draw do
  get "users", to: "users#index"
  get ":username", to: "users#show", as: "profile"
end
