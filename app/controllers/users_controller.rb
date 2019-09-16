class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :cur_user, only: [:edit, :password_edit, :update]

  def new
    @user = User.new
    @address = @user.addresses.new
  end

  def create
    @user = User.create(user_params)
    @address = @user.addresses.create!(address_params)
    if @user.save && @address.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}! You are now registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end


  def show
      @user = current_user
  end

  def edit
  end

  def password_edit
  end

  def update
    @user.update(user_params)
    if user_params.include?(:password)
      redirect_to '/profile'
      flash[:success] = 'Your password has been updated'
    elsif @user.save
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

  def address_params
    params.permit(:address, :city, :state, :zip)
  end

  def cur_user
    @user = current_user
  end
end
