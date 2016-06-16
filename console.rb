#!/usr/bin/env bundle exec ruby

require "./db/setup"
require "./lib/all"

class PrivateExample
  def public_token
    (id + ":" + secret).reverse
  end

  private

  def id
    "asdfasdfasdf"
  end

  def secret
    "qwerqwerqwer"
  end
end

binding.pry
