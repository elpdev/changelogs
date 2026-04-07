module AuthenticationHelpers
  def login_user(user)
    post session_path, params: {email_address: user.email_address, password: "MyString"}
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
