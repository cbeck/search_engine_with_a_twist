require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_writer :data
  attr_protected :admin

  before_save :encrypt_password
  before_validation :update_data
  before_create :make_activation_code

  acts_as_paranoid
  acts_as_commentable

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 6..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
      :message => 'email must be valid'
  # validates_associated [:phones, :location, :person], :allow_nil => true
  
  # has_one :location,  :as => :addressable,  :dependent => :destroy
  # has_many :phones,   :as => :callable,     :dependent => :destroy
  has_one :person,   :as => :personable,   :dependent => :destroy
  has_many :sites, :conditions  => ['disabled IS NULL or disabled = ?', false]

  def passwd(p)
    self.password = p
    self.password_confirmation = p
    save(false) && "password reset"
  end

  # Activates the user in the database.
  def activate(notify = true)
    self.activation_code = nil
    self.activated_at = Time.now.utc
    @activated = true if notify
    save(false)
  end

  def activated?
    # !! activation_code.nil?
    activation_code.nil?
  end

  def recently_activated?
    @activated
  end
  
  def forgot_password
    self.crypted_password = nil
    self.make_password_reset_code
    @forgotten_password = true
    save(false)
  end
  
  def recently_forgot_password?
    @forgotten_password
  end
 
  def reset_password    
    self.password_reset_code = nil
    self.password_reset_at = Time.now.utc
    @reset_password = true
    save(false)
  end
 
  def recently_reset_password?
    @reset_password
  end
      
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]    
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def self.per_page
    10
  end
  
  def is_ubexactor?
    (!ub_override.nil? && ub_override == 'ubexactor') || (self.sites.count > 39 && !is_ubexpert?)
  end
  
  def is_ubexpert?
    admin? || (!ub_override.nil? && ub_override == 'ubexpert') || self.sites.count > 399 
  end
  
  def is_ubsomething?
    self.is_ubexactor? || self.is_ubexpert?
  end
  
  def links_accepted
    number = sites.size
    if is_ubexactor?
      return (number < 40) ? "Between 40 and 400" : number
    else 
      return (number > 399) ? number : "1200+" # specified by W
    end
  end
  
  def name
    name = "Unknown"
    name = person.name unless person.nil?
    name
  end
  
  def location
    loc = ""
    unless person.nil? 
      loc << person.country unless person.country.nil? 
      loc << " (#{person.city})" unless person.city.nil?
    end
    (loc.blank?) ? "Unknown" : loc
  end
  

  protected
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_activation_code
      self.activation_code = 
        Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  def make_password_reset_code
    self.password_reset_code = 
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
    
  def password_required?
    open_id_url.nil? && (crypted_password.blank? || !password.blank?)
  end
  
  
  private
  def update_data
    if @data && @data[:person]
      if new_record?
        build_person(@data[:person]) 
      else
        if @data[:person][:country].blank? && !person.country.blank?
          @data[:person][:country] = person.country
        end
        person.update_attributes(@data[:person])
      end
    end
  end 
  
end
