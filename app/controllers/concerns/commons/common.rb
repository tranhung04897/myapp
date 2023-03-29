module Commons::Common
  def current_per_page
    @current_per_page = params[:paging] || Settings.per_page
  end

  def load_per_page_params
    return unless params[:paging].present? && Settings.item_paging.map { |key| key[1] }.exclude?(params[:paging])

    params[:paging] = Settings.per_page
  end
end
