Factory.define do
  factory :user do
    name_first "John"
    name_last "Doe"
    password "foobar"
    password_confirmation "foobar"
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :album do
    name "Self-Titled"
    release_date { 3.years.ago }
  end

  factory :artist do
    name_stage "The Band"
  end

  factory :city do
    name "New York City"
  end

  factory :concert do
    venue
  end

  factory :country do
    name 'USA'
  end

  factory :song do
    name "The Song"
    album
  end

  factory :state do
    name "State"
    abbreviation "ST"
  end

  factory :venue do
    name "The Venue"
    city
  end

  factory :paperclip_attachment_album do
    album_cover_file_name { 'test.jpg' }
    album_cover_type { 'image/jpeg' }
    album_cover_file_size { 1024 }
    album_cover_uploaded_at { 2.weeks.ago }
  end

  factory :paperclip_attachment_artist do
    avatar_file_name { 'test.jpg' }
    avatar_content_type { 'image/jpeg' }
    avatar_file_size { 1024 }
    avatar_uploaded_at { 2.weeks.ago }
  end

  factory :paperclip_attachment_user do
    profile_pic_file_name { 'test.jpg' }
    profile_pic_content_type { 'image/jpeg' }
    profile_pic_file_size { 1024 }
    profile_pic_uploaded_at { 2.weeks.ago }
  end


end