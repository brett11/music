module ArtistsHelper
  def sortable_artist(current_route, column, column_table = "Artist", title = nil)
    # binding.pry
    title ||= column.titleize
    css_class = column == sort_column(column_table) && column_table == sort_table ? "current #{sort_direction}" : nil
    direction = column == sort_column(column_table) && sort_direction == "asc" ? "desc" : "asc"
    # will merge with existing params, notably search and my_favs, see railscasts240
    button_to title, "#{current_route}", { method: :get, params: request.query_parameters.merge({sort_table: column_table, sort: column, direction: direction, page: nil}), class: css_class}
  end
end
