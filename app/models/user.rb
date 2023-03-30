class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         authentication_keys: [:login_id, :password]

  attr_accessor :current_password, :login_id, :current_user, :new_password

  has_many :tracking_histories

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false },
            format: { with: Settings.regex_email }, if: -> { username.present? }
  belongs_to :role
  validates :name, presence: true
  validates_length_of :name, maximum: 255, allow_blank: true
  validates :password, presence: true, if: :password_empty? || :new_password_nil?
  validates :password, length: { minimum: 6, maximum: 12 }, allow_blank: true
  validates_confirmation_of :password
  delegate :name, to: :role, prefix: :role, allow_nil: true

  def login
    @login_id || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login_id)
    pwd = conditions.delete(:password)
    user = where(conditions.to_h)
           .where(['(lower(username) = :value OR lower(email) = :value)', { value: login.downcase }])
           .detect { |u| u.valid_password?(pwd) }
  end


  def is_admin?
    is_role?('admin')
  end

  def is_manager?
    is_role?('manager')
  end

  def is_role?(role_name)
    role&.name == role_name
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  protected

  def validate_username

  end

  def new_password_nil?
    new_password.nil?
  end

  def new_password_empty?
    !new_password_nil? && new_password&.empty?
  end

  def password_empty?
    new_password_nil? && password&.empty?
  end

  def password_valid?
    changes['encrypted_password']
  end
end
