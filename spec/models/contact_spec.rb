require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'name' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    it 'cannot have special character' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + "." + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name no special characters, only letters and numbers")
    end

    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: "",
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end

  context 'email' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    it 'must be valid email address' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Name.first_name.downcase + ".com",
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid")
    end

    it 'cannot have duplicate under user scope' do
      email = Faker::Internet.email
      user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      )
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: email, # same email
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
    end

    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: "",
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid, Email can't be blank")
    end
  end

  context 'birth_date' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    it 'must be ISO 8601' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Base.numerify('##-##-####'),
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Birth date invalid ISO 8601 date, Birth date can't be blank")
    end

    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: "",
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Birth date can't be blank")
    end
  end

  context 'phone' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    it 'can be (+##) ###-###-##-## format' do
      expect(user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      )).to be_truthy
    end

    it 'can be (+##) ### ### ## ## format' do
      expect(user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ### ### ## ##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      )).to be_truthy
    end
    
    it 'cannot have other format' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ##########'),
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Phone phone numbers must be in '(+00) 000 000 00 00' or '(+00) 000-000-00-00' formats")
    end

    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: "",
        address: Faker::Address.street_address,
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Phone phone numbers must be in '(+00) 000 000 00 00' or '(+00) 000-000-00-00' formats, Phone can't be blank")
    end
  end

  context 'address' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: "",
        credit_card: Faker::Finance.credit_card(:mastercard, :visa)
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Address can't be blank")
    end
  end

  context 'credit_card' do
    let (:user) { User.create(Faker::Internet.user('email', 'password')) }
    
    it 'cannot be invalid' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: Faker::Base.numerify('############')
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Credit card invalid credit card, Franchise can't be blank")
    end

    it 'cannot be empty' do
      expect { user.contacts.create!(
        name: Faker::Name.first_name + Faker::Name.last_name,
        email: Faker::Internet.email,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
        phone: Faker::Base.numerify('(+##) ###-###-##-##'),
        address: Faker::Address.street_address,
        credit_card: ""
      ) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Credit card invalid credit card, Credit card can't be blank, Franchise can't be blank")
    end
  end
end
