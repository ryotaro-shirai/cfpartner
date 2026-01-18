FactoryBot.define do
  factory :event do
    sequence(:name) { |i| "TestEvent#{i}" }
    url { "https://www.yahoo.co.jp/" }
    cfp_status { "no_information" }
    event_start_at { rand(1..30).days.from_now }
    event_end_at { event_start_at + rand(1..30).days }
    event_homepage_url { Faker::Internet.url }
  end
end
