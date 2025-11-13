FactoryBot.define do
  factory :event do
    sequence(:name) { |i| "TestEvent#{i}" }
    url { "https://www.yahoo.co.jp/" }
    cfp_status { "now_on_call" }
    cfp_start_at { rand(1..30).days.from_now }
    cfp_end_at { cfp_start_at + rand(1..30).days }
  end
end
