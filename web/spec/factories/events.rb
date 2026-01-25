FactoryBot.define do
  factory :event do
    name { Faker::Internet.name }
    site_url { Faker::Internet.url }
    status { :published_information }
    start_at { rand(31..40).days.from_now }
    end_at { rand(40..50).days.from_now }
    deplicated_cfp_site_url { Faker::Internet.url }

    trait :now_on_the_event do
      status { :now_on_the_event }
    end

    trait :after_the_event do
      status { :after_the_event }
    end
  end
end
