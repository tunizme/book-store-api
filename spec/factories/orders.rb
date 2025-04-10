FactoryBot.define do
  factory :order do
    user { nil }
    total_amount { "9.99" }
    address { "MyString" }
    phone { "MyString" }
  end
end
