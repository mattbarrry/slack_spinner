# frozen_string_literal: true

module Slack
  class Api
    attr_reader :client_id, :client_secret

    def initialize
      @client_id = slack_config.client_id
      @client_secret = slack_config.client_secret
    end

    def new_access_token(code:, redirect_uri: nil)
      params = authorization_params(code: code, redirect_uri: redirect_uri)
      response = api.get('/oauth.v2.access', params)

      JSON.parse(response.body, symbolize_keys: true)
    end

    private

    def slack_config
      @slack_config ||= Rails.application.config.slack
    end

    def api
      @api ||= Faraday.new(url: slack_config.base_url)
    end

    def authorization_params(code:, redirect_uri: nil)
      {
        code: code,
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri
      }
    end
  end
end