class OsiCasController < RoleApplicationController
  include Commons::Common

  before_action :load_per_page_params, :current_per_page, :load_osi_cas, only: :index
  before_action :set_osi_ca, only: %i[ show edit update destroy ]

  # GET /osi_cas or /osi_cas.json
  def index
    @text_search = params['q']['id_or_name_or_code_or_syntax_osi_cont'] rescue ''
    @q = @osi_cas.ransack(params[:q])
    result = @q.result.page(params[:page])
    @osi_cas = @current_per_page == Settings.item_paging_all ? result.per(@osi_cas.count) : result.per(@current_per_page)
  end

  # GET /osi_cas/1 or /osi_cas/1.json
  def show
  end

  # GET /osi_cas/new
  def new
    @osi_ca = OsiCa.new
  end

  # GET /osi_cas/1/edit
  def edit
  end

  # POST /osi_cas or /osi_cas.json
  def create
    @osi_ca = OsiCa.new(osi_ca_params)

    respond_to do |format|
      if @osi_ca.save
        format.html { redirect_to osi_cas_path, success: "Osi ca was successfully created." }
        format.json { render :show, status: :created, location: @osi_ca }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @osi_ca.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /osi_cas/1 or /osi_cas/1.json
  def update
    respond_to do |format|
      format.html {
        if @osi_ca.update(osi_ca_params)
          redirect_to osi_cas_path(@osi_ca), success: "Osi ca was successfully updated."
        else
          render :edit
        end
      }
    end
  end

  # DELETE /osi_cas/1 or /osi_cas/1.json
  def destroy
    @osi_ca.destroy

    respond_to do |format|
      format.html { redirect_to osi_cas_url, success: "Osi ca was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_osis
    ids = JSON.parse(params['ids']).compact
    OsiCa.where(id: ids).delete_all
    render js: 'window.location.reload();'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_osi_ca
    @osi_ca = OsiCa.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def osi_ca_params
    params.require(:osi_ca).permit(:name, :code, :syntax_osi, :limit_value)
  end

  def load_osi_cas
    @osi_cas = OsiCa.accessible_by(current_ability)
  end
end
