class OrdersController <ApplicationController

  # def new
  #   @user = current_user
  # end

  def show
    # binding.pry
    @order = Order.find(params[:order_id])
    @user = current_user
  end

  def edit
    @order = Order.find(params[:order_id])
  end

  def index
    @user = current_user
  end

  def create
    if !params[:order]
      flash[:error] = "Please Select an Address"
      redirect_to '/cart'
    else
      user = current_user
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
      end
    end
  end

  def update
    # binding.pry
    order = Order.find(params[:order_id])
    # address_id = params[:address_id]
    # binding.pry
    order.update(address_id: (params[:address_id]))
    redirect_to "/profile/orders/#{order.id}"
    # binding.pry
    # address
    # order = user.orders.create!(address_id: order_params[:address_id])
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
    # binding.pry
    params.require(:order).permit(:address_id)
  end
end
