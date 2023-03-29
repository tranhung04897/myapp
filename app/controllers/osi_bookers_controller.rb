class OsiBookersController < RoleApplicationController
  include Commons::Common

  before_action :load_per_page_params, :current_per_page, :load_osi_bookers, only: :index
  before_action :set_osi_booker, only: %i[ show edit update destroy ]

  # GET /osi_bookers or /osi_bookers.json
  def index
    @text_search = params['q']['id_or_name_or_code_or_syntax_osi_cont'] rescue ''
    @q = @osi_bookers.ransack(params[:q])
    result = @q.result.page(params[:page])
    @osi_bookers = @current_per_page == Settings.item_paging_all ? result.per(@osi_bookers.count) : result.per(@current_per_page)
  end

  # GET /osi_bookers/1 or /osi_bookers/1.json
  def show
  end

  # GET /osi_bookers/new
  def new
    @osi_booker = OsiBooker.new
  end

  # GET /osi_bookers/1/edit
  def edit
  end

  # POST /osi_bookers or /osi_bookers.json
  def create
    @osi_booker = OsiBooker.new(osi_booker_params)

    respond_to do |format|
      if @osi_booker.save
        format.html { redirect_to osi_bookers_path, success: "Osi booker was successfully created." }
        format.json { render :show, status: :created, location: @osi_booker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @osi_booker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /osi_bookers/1 or /osi_bookers/1.json
  def update
    respond_to do |format|
      if @osi_booker.update(osi_booker_params)
        format.html { redirect_to osi_bookers_path, success: "Osi booker was successfully updated." }
        format.json { render :show, status: :ok, location: @osi_booker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @osi_booker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /osi_bookers/1 or /osi_bookers/1.json
  def destroy
    @osi_booker.destroy

    respond_to do |format|
      format.html { redirect_to osi_bookers_url, success: "Osi booker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_osis
    ids = JSON.parse(params['ids']).compact
    OsiBooker.where(id: ids).delete_all
    render js: 'window.location.reload();'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_osi_booker
    @osi_booker = OsiBooker.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def osi_booker_params
    params.require(:osi_booker).permit(:name, :code, :syntax_osi)
  end

  def load_osi_bookers
    @osi_bookers = OsiBooker.accessible_by(current_ability)
  end
end
