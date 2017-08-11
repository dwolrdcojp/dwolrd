class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:notify]
  skip_before_action :verify_authenticity_token
  protect_from_forgery :except => [:notify]
  rescue_from ActiveRecord::RecordNotFound, with: :rescue
  rescue_from ActionView::MissingTemplate, with: :rescue

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
    @@order = Order.new(order_params)
    @item = Item.find(params[:item_id])
    @seller = @item.user

    @@order.item_id = @item.id
    @@order.buyer_id = current_user.id
    @@order.seller_id = @seller.id

    # p = Print.find_by(id: params[:id])
    # creator = Creator.find_by(id: p.creator_id)
    price = (@item.price + @item.shipping_price.to_i)
    commission = 0.06

    # Build API call
    @api = PayPal::SDK::AdaptivePayments.new
    @pay = @api.build_pay({
      :actionType => "PAY",
      :cancelUrl => "https://www.d-wolrd.com" + new_item_order_path,
      :returnUrl => root_url,
      :currencyCode => "USD",
      :feesPayer => "PRIMARYRECEIVER",
      :ipnNotificationUrl => "https://www.d-wolrd.com" + paypal_ipn_notify_path,
      :receiverList => {
        :receiver => [
          {
            :amount => price,
            :email => @@order.item.paypal_email,
            :primary => true
          },
          {
            :amount => price * commission,
            :email => "dwolrdcojp@gmail.com",
            :primary => false
          }
        ]
      }})

   # Make API call
    @pay_response = @api.pay(@pay)

    # Check if call was valid, if so, redirect to PayPal payment url
    if @pay_response.success? && params[:order].values_at(:name, :address, :city, :state, :zip, :country).all?(&:present?)
      @pay_response.payKey
      redirect_to @api.payment_url(@pay_response)
    else
      redirect_to new_item_order_path, alert: @pay_response.error[0].message
    end

  end

  def notify
    response = validate_IPN_notification(request.raw_post)
    case response
    when "VERIFIED"
      @@order.save
    when "INVALID"
      @@order.save
    else
      @@order.save
    end
    render :nothing => true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def rescue
      redirect_to root_url
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :city, :state, :zip, :country)
    end

  protected
  def validate_IPN_notification(raw)
    uri = URI.parse('https://ipnpb.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body
  end

end
