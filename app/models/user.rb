class User < ActiveRecord::Base
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  include Curate::UserBehavior

  # Connects this user object to Hydra behaviors.
  include Hydra::User

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable


  def self.search(query = nil)
    if query.to_s.strip.present?
      term = "#{query.to_s.upcase}%"
      where("UPPER(email) LIKE :term OR UPPER(name) LIKE :term", {term: term})
    else
      all
    end.order(:email)
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def username
    email
  end

end
