class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  # GET /orders/new
  def new
    @order = Order.new
    @item = Item.find(params[:item_id])
    gon.client_token = generate_client_token
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @item = Item.find(params[:item_id])
    @seller = @item.user

    @order.item_id = @item.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    @result = Braintree::Transaction.sale(
              :amount => "10.00",
              payment_method_nonce: params[:payment_method_nonce])

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        flash[:alert] = "Something went wrong :("
        gon.client_token = generate_client_token
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end

    def generate_client_token
      Braintree::ClientToken.generate
    end
end
