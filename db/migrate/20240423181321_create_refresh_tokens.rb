class CreateRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.integer :expires_at

      t.timestamps
    end
  end
end
