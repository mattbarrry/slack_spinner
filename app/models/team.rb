class Team < ApplicationRecord
  def self.slack_lookup(token)
    slack_team_id = token[:team][:id]
    Team.find_or_create_by(slack_id: slack_team_id) do |team|
      team.access_token = token[:access_token]
      team.name = token[:team][:name]
    end
  end
end
