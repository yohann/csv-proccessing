## Dependencies
The API must have
  - Ruby 3.0.0
  - Rails 7.0.3
  - PostgreSQL 12.10

<br />

## Installation
### Instal gems
```
bundle install
```

### Create database
```
bundle exec rails db:create
bundle exec rails db:schema:load
```

### Run Server
```
bundle exec rails s
```

#### Navigating in the application
- Sign up: http://localhost:3000/users/sign_up
- Sign in: http://localhost:3000/users/sign_in
- Import contacts: http://localhost:3000/contacts/new
- List contacts: http://localhost:3000/contacts