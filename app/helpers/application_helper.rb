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
        linkTitle += "#{concert.venue.name}"
    end
end
