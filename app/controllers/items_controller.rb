class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :deny_access
  rescue_from ActionView::MissingTemplate, with: :template_not_found
      

  def garage
    @items = current_user.items
  end

  def show
    @item = Item.find(params[:id])
  end

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    if params[:search]
      @items = Item.search(params[:search]).order("created_at DESC")
    else
      @items = Item.all.order("created_at DESC")
    end
  end

  # GET /items/new
  def new
    @item = current_user.items.build
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = current_user.items.build(item_params)
    @item.username = current_user.username

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def favorite
    @item = Item.find(params[:id])
    type = params[:type]
    if type == "favorite"
      current_user.favorites << @item
      redirect_to :back

    elsif type == "unfavorite"
      current_user.favorites.delete(@item)
      redirect_to :back

    else
      redirect_to :back
    end
  end

  def favorites
    @items = current_user.favorites
  end

  def deny_access
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def template_not_found
    redirect_to :back
  rescue ActionView::MissingTemplate
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :content, :filepicker_url, :price, :shipping_price)
    end
end
