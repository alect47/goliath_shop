class OrdersController <ApplicationController
  before_action :set_user, only: [:show, :create, :index, ]

  def show
    @order = Order.find(params[:order_id])
    address = @order.address.id
    @unused_addresses = @order.unused_addresses(address)
  end

  def index
  end

  def create
    if !params[:order]
      flash[:error] = "Please Select an Address"
      redirect_to '/cart'
    else
      order = @user.orders.create!(address_id: order_params[:address_id])
      if order.save
        cart.items.each do |item,quantity|
          order.item_orders.create({
            item: item,
            quantity: quantity,
            price: item.price,
            merchant_id: item.merchant_id
            })
        end
        session.delete(:cart)
        flash[:success] = "Order Created!"
        redirect_to "/profile/orders"
      end
    end
  end

  def update
    order = Order.find(params[:order_id])
    if order.pending_order?
      order.update(address_id: (params[:address_id]))
      flash[:success] = "Address changed to #{order.address.nickname}"
      redirect_to "/profile/orders/#{order.id}"
    end
  end

  def cancel
    order = Order.find(params[:order_id])
      order.item_orders.each do |item_order|
        item_order[:status] = "unfulfilled"
        item = Item.find(item_order.item_id)
        item.add(item_order.quantity)
      end
    order.update(status: 3)
    redirect_to "/profile"
    flash[:success] = ("Order #{order.id} has been cancelled")
  end

  private

  def order_params
    params.require(:order).permit(:address_id)
  end

  def set_user
    @user = current_user
  end
end
