module SlackHelper
  def add_to_slack_url
    [slack_config.auth_url, params.to_query].join('?')
  end

  private

  def params
    {
      client_id: slack_config.client_id,
      scope: slack_config.scope,
      redirect_uri: slack_auth_url,
    }
  end

  def slack_config
    @slack_config ||= Rails.application.config.slack
  end
end
