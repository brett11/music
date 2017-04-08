module ApplicationHelper
    def titleGenerator(additional_title = "")
        base_title = "MyFavArtists"
        if additional_title.empty?
            base_title
        else
            base_title +": "+additional_title
        end
    end
end
