module AlbumsHelper
  def sortable_album(current_route, column, column_table = "Album", title = nil)
    # binding.pry
    title ||= column.titleize
    css_class = column == sort_column(column_table) && column_table == sort_table ? "current #{sort_direction}" : nil
    direction = column == sort_column(column_table) && sort_direction == "asc" ? "desc" : "asc"
    button_to title, "#{current_route}", { method: :get, params: request.query_parameters.merge({sort_table: column_table, sort: column, direction: direction, page: nil}), class: css_class}
  end
end
