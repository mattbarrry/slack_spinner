module Slack
  class SpinsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      response_url = params[:response_url]
      text = params[:text]

      valid_slack_request? ? (head :ok) : (head :bad_request)
    end

    private

    # https://api.slack.com/authentication/verifying-requests-from-slack
    def valid_slack_request?
      Rails.logger.info "Calculating #{calculated_secret} : #{request.headers['X-Slack-Signature']}"
      calculated_secret == request.headers['X-Slack-Signature']
    end

    def calculated_secret
      request_timestamp = request.headers['X-Slack-Request-Timestamp']
      return false if 5.minutes.ago > Time.zone.at(request_timestamp.to_i) # replay attacks

      request_body = request.raw_post
      our_secret = calc_digest("v0:#{request_timestamp}:#{request_body}")

      "v0=#{our_secret}"
    end

    def calc_digest(data)
      key = Rails.application.config.slack.signing_secret
      digest = OpenSSL::Digest.new('sha256')

      OpenSSL::HMAC.hexdigest(digest, key, data)
    end
  end
end
