class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  require 'paypal-sdk-adaptivepayments'

  def pay
    p = Print.find_by(id: params[:id])
    user = current_user
    price = @order.item.price
    commission = 0.06

    # Build API call
    @api = PayPal::SDK::AdaptivePayments.new
    @pay = @api.build_pay({
      :actionType => "PAY",
      :cancelUrl => "http://localhost:3000/p/#{p.id}",
      :returnUrl => "http://localhost:3000/#{p.path}",
      :currencyCode => "USD",
      :feesPayer => "PRIMARYRECEIVER",
      :ipnNotificationUrl => "http://localhost:3000/paypal/ipn_notify",
      :receiverList => {
        :receiver => [{
          :amount => price,
          :email => current_user.email,
          :primary => true },
        {
          :amount => price * (1 - commission),
          :email => User.find(@order.item.user_id).email,
          :primary => false }]
        },
        :memo => "Transaction for #{p.username}"
      } || default_api_value)

    # Make API call & get response
    @response = @api.pay(@pay)

    # Access response
    if @response.success? && @response.payment_exec_status != "ERROR"
      @response.payKey
      @api.payment_url(@response)  # Url to complete payment
    else
      @response.error[0].message
    end
  end

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

    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = params[:stripeToken]

    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => (@item.price * 100).floor,
        :currency => "usd"
      )
      flash[:notice] = "Thanks for ordering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      redirect_to new_order_path
    end

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @order }
      else
        flash[:alert] = "Something went wrong :("
        # gon.client_token = generate_client_token
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

end
