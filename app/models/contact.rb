class Contact < ApplicationRecord
  attr_accessor :invalid_iso_birth_date
  attr_accessor :invalid_credit_card
  belongs_to :user

  NAME_VALIDATION_REGEX = /^[a-zA-Z\d\s-]*$/
  PHONE_VALIDATION_REGEX = /\(\+[0-9]{2}\) [0-9]{3}(-| )[0-9]{3}(-| )[0-9]{2}(-| )[0-9]{2}/

  validate :date_format
  validate :credit_card_validation
  validates :name, format: {
    with: NAME_VALIDATION_REGEX,
    message: 'no special characters, only letters and numbers',
    multiline: true
  }
  validates :phone, format: {
    with: PHONE_VALIDATION_REGEX,
    message: "phone numbers must be in '(+00) 000 000 00 00' or '(+00) 000-000-00-00' formats"
  }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
  
  validates_presence_of :name, :email, :birth_date, :phone, :address, :credit_card, :franchise
  

  def birth_date=(value)
    begin
      Date.iso8601(value) if value.present?
      super(value)
    rescue Date::Error
      @invalid_iso_birth_date = true
    end
  end
  
  def credit_card=(number)
    detector = CreditCardValidations::Detector.new(number)
    self.franchise = detector.brand.to_s
    @invalid_credit_card = true unless self.franchise && detector.valid?(self.franchise)
    number = "*" * (number.size - 4) + number[-4, 4] if number.size > 4
    super(number)
  end
  
  private
  def date_format
    errors.add(:birth_date, :invalid, message: "invalid ISO 8601 date") if @invalid_iso_birth_date
  end
  
  def credit_card_validation
    errors.add(:credit_card, :invalid, message: "invalid credit card") if @invalid_credit_card
  end
end
