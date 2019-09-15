class OrdersController <ApplicationController

  def new
    @user = current_user
  end

  def show
    # binding.pry
    @order = Order.find(params[:order_id])
    @user = current_user
  end

  def index
    @user = current_user
  end

  def create
    # binding.pry
    user = current_user
    # user = User.find(session[:user_id])
    # order = user.orders.create!(address_id: user.address.id)
    order = user.orders.create!(address_id: order_params[:address_id])
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
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
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
end
