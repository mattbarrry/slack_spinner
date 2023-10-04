# frozen_string_literal: true

module Slack
  class AuthsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      token = slack_api.new_access_token(code: params[:code], redirect_uri: slack_auth_url)

      redirect_to root_url, alert: token_error_message(token) unless token[:ok]

      team = Team.slack_lookup(token)

      if team.save
        redirect_to root_url, notice: success_message
      else
        redirect_to root_url, alert: error_message
      end
    end

    private

    def slack_api
      @slack_api ||= Slack::Api.new
    end

    def token_error_message(token)
      Rails.logger.error "Issue connecting to Slack: #{token[:error]} with params #{params}"

      error_message
    end

    def success_message
      'Successfully added SlackSpinner to your Slack workspace!'
    end

    def error_message
      'Something went wrong. Please try again later.'
    end
  end
end