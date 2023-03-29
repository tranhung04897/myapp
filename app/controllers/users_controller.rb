class UsersController < RoleApplicationController
  include Commons::Common

  before_action :load_per_page_params, :current_per_page, :load_users, only: :index

  def index
    @text_search = params['q']['id_or_username_or_name_cont'] rescue ''
    @q = @users.ransack(params[:q])
    result = @q.result.page(params[:page])
    @users = @current_per_page == Settings.item_paging_all ? result.per(@users.count) : result.per(@current_per_page)
  end

  def delete_users
    ids = JSON.parse(params['ids']).compact
    User.where(id: ids).delete_all
    render js: 'window.location.reload();'
  end

  private

  def load_users
    @users = if current_user.is_admin?
               User
             else
               User.joins(:role).where("role_id IN (?)", [2,3])
             end.includes(:role).accessible_by(current_ability)
  end
end
