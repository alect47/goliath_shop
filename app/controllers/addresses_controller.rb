class AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    @address = Address.find(params[:address_id])
    @address.update(address_params)
    if @address.save
      redirect_to "/profile"
    else
      flash[:error] = @address.errors.full_messages.uniq.to_sentence
      render :edit
    end
  end


  #why do i have an order in here?

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
    @address = Address.find(params[:address_id])
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

end
