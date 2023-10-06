# frozen_string_literal: true

module Slack
  class AuthsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      redirect_to root_url, alert: error_message unless token[:ok]

      team = Team.slack_lookup(token)

      team.save ? (redirect_to root_url, notice: success_message) : (redirect_to root_url, alert: error_message)
    end

    private

    def slack_api
      @slack_api ||= Slack::Api.new
    end

    def token
      @token ||= slack_api.new_access_token(code: params[:code], redirect_uri: slack_auth_url)
    end

    def success_message
      'Successfully added SlackSpinner to your Slack workspace!'
    end

    def error_message
      Rails.logger.error "Issue connecting to Slack: #{token[:error]} with params #{params}"

      'Something went wrong. Please try again later.'
    end
  end
end
