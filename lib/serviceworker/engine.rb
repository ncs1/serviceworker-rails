# frozen_string_literal: true

require "rails"
require "rails/railtie"
require "serviceworker"

module ServiceWorker
  class Engine < ::Rails::Engine
    config.serviceworker = ActiveSupport::OrderedOptions.new
    config.serviceworker.headers = {}
    config.serviceworker.routes = ServiceWorker::Router.new
    config.serviceworker.handler = :sprockets
    config.serviceworker.icon_sizes = %w[
      16 32 36 48 60 64 72 76 96 114 120 144 152 160 180 192 196 256 384 512
    ]

    initializer "serviceworker-rails.configure_rails_initialization", after: :load_config_initializers do
      config.serviceworker.logger ||= ::Rails.logger

      if config.respond_to?(:assets)
        config.assets.precompile += %w[serviceworker-rails/*.png]
      elsif app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[serviceworker-rails/*.png]
      end

      app.middleware.use ServiceWorker::Middleware, config.serviceworker
    end

    def app
      ::Rails.application
    end
  end
end
