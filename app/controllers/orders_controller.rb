class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :deny_access
  rescue_from ActionView::MissingTemplate, with: :template_not_found


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

    # p = Print.find_by(id: params[:id])
    # creator = Creator.find_by(id: p.creator_id)
    price = (@item.price + @item.shipping_price.to_i)
    commission = 0.06

    # Build API call
    @api = PayPal::SDK::AdaptivePayments.new
    @pay = @api.build_pay({
      :actionType => "PAY",
      :cancelUrl => "http://localhost:3000/",
      :returnUrl => "http://localhost:3000/",
      :currencyCode => "USD",
      :feesPayer => "PRIMARYRECEIVER",
      :ipnNotificationUrl => "http://localhost:3000/paypal/ipn_notify",
      :receiverList => {
        :receiver => [
          {
            :amount => price,
            :email => "dwolrdcojp-facilitator@gmail.com",
            :primary => true
          },
          {
            :amount => (price * (1 - commission)).round(2),
            :email => "dwolrdcojp_seller@example.com",
            :primary => false
          }
        ]
      }})

   # Make API call
    @pay_response = @api.pay(@pay)

    # Check if call was valid, if so, redirect to PayPal payment url
    if @pay_response.success?
      @pay_response.payKey
      redirect_to @api.payment_url(@pay_response)
    else
      redirect_to root_path, alert: @pay_response.error[0].message
    end



    # token = params[:stripeToken]

    # begin
    
    # # customer = Stripe::Customer.create(
    # #     :email => params[:stripeEmail],
    # #     :source  => token
    # # )

    # require 'json'

    #   charge = Stripe::Charge.create({
    #     :source => token,
    #     :amount => ((@item.price + @item.shipping_price.to_i) * 100),
    #     :currency => "usd",
    #     :description => @item.title,
    #     :application_fee => (((@item.price + @item.shipping_price.to_i) * 100) * 0.06).floor
    #   },
    #   {:stripe_account => @item.user.uid }
    # )
    #   @order.name = params[:stripeShippingName]
    #   @order.address = params[:stripeShippingAddressLine1]
    #   @order.city = params[:stripeShippingAddressCity]
    #   @order.state = params[:stripeShippingAddressState]
    #   @order.zip = params[:stripeShippingAddressZip]
    #   @order.country = params[:stripeShippingAddressCountry]

    #   flash[:notice] = "Thanks for ordering!"
    # rescue Stripe::CardError => e
    #   flash[:danger] = e.message
    #   redirect_to new_item_order_path
    # end

    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to root_url }
    #     format.json { render :show, status: :created, location: @order }
    #   else
    #     flash[:alert] = "Something went wrong :("
    #     # gon.client_token = generate_client_token
    #     format.html { render :new }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
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
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      if params[:orders] && params[:orders][:stripe_card_token].present?
        params.require(:orders).permit(:stripe_card_token)
      end
    end

end
