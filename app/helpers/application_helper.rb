module ApplicationHelper

    def titleGenerator(additional_title = "")
        base_title = "MyFavArtists"
        if additional_title.empty?
            base_title
        else
            base_title +": "+additional_title
        end
    end

    def buttonTitle(custom_title = "")
        base_title = "Submit"
        if custom_title.empty?
            base_title
        else
            base_title = custom_title
        end
    end

    def linkTitleGenerator(concert)
        linkTitle = ""
        linkTitle += concert.dateandtime.strftime("%m/%d/%Y") + ": "
        concert.artists.each do |artist|
            linkTitle += "#{artist.name_stage}, "
        end
        if concert.venue.name != "na"
          linkTitle += "#{concert.venue.name}, "
        end
        linkTitle += full_city_name(concert.venue.city)
    end

    def venueLinkTitleGenerator(venue)
        linkTitle = ""
        linkTitle += venue.name + ": "
        linkTitle += venue.city.full_name
    end

    def linkTitleGeneratorLessName(concert)
      linkTitle = ""
      linkTitle += concert.dateandtime.strftime("%m/%d/%Y") + ": "
      linkTitle += "#{concert.venue.name}, "
      linkTitle += full_city_name(concert.venue.city)
    end

    def linkAlbumGenerator(album)
        linkTitle = "#{album.name}"
        linkTitle += ", " + album.artists.map {|artist|
            artist.name_stage}.join(', ')
    end

    def full_city_name(city)
        if city.country.name == "USA" && city.name != "Washington DC"
            city_name = city.name + ", " + city.state.abbreviation + ", " + city.country.name
        else
            city_name = city.name + ", " + city.country.name
        end
    end

end
