FactoryBot.define do
  factory :talk_recruitment do
    title { Faker::Lorem.word + "cfp" }
    recruitment_site { Faker::Internet.url }
    status { :no_information }
    talk_type { :no_information }
    start_at { rand(11..20).days.from_now }
    end_at { rand(21..30).days.from_now }
    event { FactoryBot.create(:event) }

    trait :before_call do
      status { :before_call }
      talk_type { :session }
    end

    trait :now_on_call do
      status { :now_on_call }
      talk_type { :session }
    end

    trait :end_of_call do
      status { :end_of_call }
      talk_type { :session }
    end

    trait :end_of_event do
      status { :end_of_event }
      talk_type { :session }
    end
  end
end
