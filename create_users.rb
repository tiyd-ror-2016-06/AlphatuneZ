require "./db/setup"
require "./lib/all"
require "./lib/time"

users_to_create =
  {
    "james" => "james",
    "test"  => "test",
    "fake"  => "fake",
    "asdf"  => "asdf",
    "blah"  => "blah",
    "newuser" => "newuser"
  }

users_to_create.keys.each do |name|
  begin
    User.create!(email: name, password: users_to_create[name])
  rescue ActiveRecord::RecordInvalid
  end
end
