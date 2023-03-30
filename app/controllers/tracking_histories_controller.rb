class TrackingHistoriesController < RoleApplicationController
  include Commons::Common

  before_action :load_per_page_params, :current_per_page, only: [:index, :show]

  def index
    trackings = TrackingHistory.all.order(date_tracking: :desc)
    @q = trackings.ransack(params[:q])
    result = @q.result.includes(:user).page(params[:page])
    @trackings = @current_per_page == Settings.item_paging_all ? result.per(trackings.count) : result.per(@current_per_page)
  end

  def show
    tracking = TrackingHistory.find_by(id: params[:id])
    return if tracking.blank?

    trackings = tracking.tracking_history_details.order(created_at: :desc)
    @q = trackings.ransack(params[:q])
    result = @q.result.page(params[:page])
    @trackings = @current_per_page == Settings.item_paging_all ? result.per(trackings.count) : result.per(@current_per_page)
  end
end
