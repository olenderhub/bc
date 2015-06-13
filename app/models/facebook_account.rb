class FacebookAccount < ActiveRecord::Base
  validates :uid, :person, presence: true

  belongs_to :person

  def self.find_or_create_for_facebook(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |facebook_account|
      facebook_account.uid = auth.uid
      facebook_account.oath_token = auth.credentials.token
      facebook_account.oauth_expires_at = Time.at(auth.credentials.expires_at)
      facebook_account.provider = auth.provider
      facebook_account.build_person(first_name: auth.info.first_name, last_name: auth.info.last_name)
    end
  end
end
