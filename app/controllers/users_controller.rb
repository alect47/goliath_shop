class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :cur_user, only: [:edit, :password_edit, :update]

  def new
    @user = User.new
    1.times {@user.addresses.build}
    # @address = @user.addresses.new
  end

  def create
    @user = User.create(parent_params)
    # @address = Address.create(address_params)
    if @user.save
      # @address = @user.addresses.create(address_params)
      # if @address.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
        redirect_to "/profile"
      # end
    else
      @address = Address.create(address_params)
      flash[:error] = (@user.errors.full_messages + @address.errors.full_messages).uniq.to_sentence
      render :new
    end
  end

  # def create
  #   @user = User.create(parent_params)
  #   # @address = Address.create(address_params)
  #   if @user.save
  #     # @address = @user.addresses.create(address_params)
  #     # if @address.save
  #       session[:user_id] = @user.id
  #       flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
  #       redirect_to "/profile"
  #     # end
  #   else
  #     # @address = Address.create(address_params)
  #     # flash[:error] = (@user.errors.full_messages + @address.errors.full_messages).uniq.to_sentence
  #     render :new
  #   end
  # end


  def show
      @user = current_user
  end

  def edit
    @address = @user.addresses.first
  end

  def password_edit
  end

  def update
    # binding.pry
    @user.update(user_params)
    @address = @user.addresses.first
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
end
