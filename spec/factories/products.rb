FactoryBot.define do
  factory :product do
    name { "Su im lang bay cuu" }
    description { "Sach trinh tham, kinh di" }
    price { 100_000 }
    stock { 10 }
  end
end