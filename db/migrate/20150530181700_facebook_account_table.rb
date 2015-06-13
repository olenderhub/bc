class FacebookAccountTable < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.string :uid
      t.string :oath_token
      t.datetime :oauth_expires_at
      t.integer :person_id
      t.string   :provider
      t.timestamps
    end
  end
end
