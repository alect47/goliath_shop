class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :cur_user, only: [:edit, :password_edit, :update, :show]
  before_action :set_address, only: [:edit, :update]

  def new
    @user = User.new
    1.times {@user.addresses.build}
  end

  def create
    @user = User.create(parent_params)
    if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
        redirect_to "/profile"
    else
      @address = Address.create(address_params)
      flash[:error] = (@user.errors.full_messages + @address.errors.full_messages).uniq.to_sentence
      render :new
    end
  end

  def show
  end

  def edit
  end

  def password_edit
  end

  def update
    @user.update(user_params)
    @address.update(address_params)
    if user_params.include?(:password)
      redirect_to '/profile'
      flash[:success] = 'Your password has been updated'
    elsif @user.save && @address.save
      redirect_to '/profile'
      flash[:success] = 'Your profile has been updated'
    else
      redirect_to '/profile/edit'
      flash[:error] = @user.errors.full_messages.uniq
    end
  end

  private

  def require_user
    render file: "/public/404" unless current_user
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def parent_params
   params.require(:user).permit(:name, :email, :password, :password_confirmation, addresses_attributes: [:address, :city, :state, :zip]) # This permits the kids params to be saved
 end

  def address_params
    params.permit(:address, :city, :state, :zip)
  end

  def cur_user
    @user = current_user
  end

  def set_address
    @address = @user.addresses.first
  end
end
