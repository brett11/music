FactoryGirl.define do
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
    #http://stackoverflow.com/questions/1484374/how-to-create-has-and-belongs-to-many-associations-in-factory-girl
    artists {[FactoryGirl.create(:artist)]}
  end

  # https://stackoverflow.com/questions/3294824/how-do-i-use-factory-girl-to-generate-a-paperclip-attachment
  #https://stackoverflow.com/questions/20197474/rspec-controller-test-error-paperclipadapterregistrynohandlererror-no-h
  factory :artist do
    name_stage "The Band"
    avatar { Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/TheBand.jpg", 'image/jpeg') }
  end

  factory :city do
    name "New York City"
    state { FactoryGirl.create(:state) }
    country { FactoryGirl.create(:country) }
  end

  factory :concert do
    venue {FactoryGirl.create(:venue)}
    #http://stackoverflow.com/questions/1484374/how-to-create-has-and-belongs-to-many-associations-in-factory-girl
    artists {[FactoryGirl.create(:artist)]}
    dateandtime { DateTime.now }
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
    abbreviation 'ST'
  end

  factory :venue do
    name "The Venue"
    city { FactoryGirl.create(:city) }
  end

  factory :paperclip_attachment_album do
    album_cover_file_name { 'test.jpg' }
    album_cover_content_type { 'image/jpeg' }
    album_cover_file_size { 1024 }
    album_cover_updated_at { 2.weeks.ago }
  end

  factory :paperclip_attachment_artist do
    avatar_file_name { 'test.jpg' }
    avatar_content_type { 'image/jpeg' }
    avatar_file_size { 1024 }
    avatar_updated_at { 2.weeks.ago }
  end

  factory :paperclip_attachment_user do
    profile_pic_file_name { 'test.jpg' }
    profile_pic_content_type { 'image/jpeg' }
    profile_pic_file_size { 1024 }
    profile_pic_updated_at { 2.weeks.ago }
  end

end