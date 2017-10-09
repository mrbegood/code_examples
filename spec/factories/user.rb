FactoryGirl.define do
  
  cycle_elements = lambda do |list, index|
    list[(index - 1) % list.size]
  end
  
  factory :user do
    sequence :name do |n|
      "Test User #{n}"
    end
    
    sequence :email do |n|
      "person#{n}@example.com"
    end
    
    sequence :location do |n|
      cycle_elements.call([
        "Minsk, Belarus", 
        "Barcelona, Spain",
        "Rome, Italy",
        "Moscow, Russia", 
        "Saint Petersburg, Russia",
        "Cairo, Egypt",
        "Mexico City, Mexico"
      ], n)
    end
    
    birthday {
      DateTime.strptime((18.years.ago.to_i - rand(0..42.years)).to_s, "%s").strftime("%F")
    }
    
    bio "Facebook bio"
    about_me "Welcome phrase"
    
    facebook_id { rand(10000000000..100000000000) }
    instagram_id { rand(10000000000..100000000000) }
    
    status User::Active
    
    request_notifications false
    message_notifications false
    
    after(:create) do |user, evaluator|
      # create authorization token
      user.tokens.create
    end
    
    trait :notification_enabled do
      message_notifications true
      request_notifications true
    end
    
    # sequence 
    
    trait :male do
      sequence(:name)  { |num|
        cycle_elements.call([
          "John Nash", 
          "Andres Gutierrez Rodriguez",
          "Juan David García",
          "Manuel Fernandez Sanmartin"
        ], num)
      } 
      
      gender User::Gender::Male
    end
    
    trait :female do
      sequence(:name)  { |num|
        cycle_elements.call([
          "Kyanie Larose",
          "Lola Penster",
          "Fasha Anuar",
          "Ayesha Khan"
        ], num)
      } 
      
      gender User::Gender::Female
    end
    
    factory :blocked_user do
      status User::Blocked
    end
    
  end
end
