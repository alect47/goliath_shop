class AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :update, :delete]

  def new
    @address = Address.new
  end

  def edit
  end

  def update
    if @address.no_shipped_orders?
      @address.update(address_params)
      if @address.save
        redirect_to "/profile"
      else
        flash[:error] = @address.errors.full_messages.uniq.to_sentence
        render :edit
      end
    else
      flash[:error] = "Sorry you can't edit this address as it is currently being use in an order"
      redirect_to '/profile'
    end
  end

  def create
    user = User.find(session[:user_id])
    @address = user.addresses.create(address_params)
    if @address.save
      flash[:success] = "New Address Added"
      redirect_to "/profile"
    else
      flash[:error] = @address.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def delete
    if @address.no_shipped_orders?
      @address.destroy
      flash[:success] = "Address has been deleted"
    else
      flash[:error] = "Sorry you can't delete this address as it is currently being use in an order"
    end
    redirect_to '/profile'
  end


  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end

  def set_address
    @address = Address.find(params[:address_id])
  end
end
