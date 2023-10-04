class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :slack_id, index: { unique: true, name: 'unique_team_slack_ids' }
      t.string :access_token
      t.string :name

      t.timestamps
    end
  end
end
