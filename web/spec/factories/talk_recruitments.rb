FactoryBot.define do
  factory :talk_recruitment do
    title { Faker::Lorem.word + "cfp" }
    site_url { Faker::Internet.url }
    status { :published_information }
    talk_type { :session }
    start_at { rand(11..20).days.from_now }
    end_at { rand(21..30).days.from_now }
    event { FactoryBot.create(:event) }

    trait :no_information do
      status { :no_information }
      site_url { nil }
      talk_type { nil }
      start_at { nil }
      end_at { nil }
    end

    trait :now_on_call do
      status { :now_on_call }
    end

    trait :finished_call do
      status { :finished_call }
    end
  end
end
