class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    user = User.find(session[:user_id])
    address = user.addresses.create(address_params)

    # @address = Address.create!(address_params)
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
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


  private

  def address_params
    params.permit(:nickname, :address, :city, :state, :zip)
  end

end
