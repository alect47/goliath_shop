class MerchantsController <ApplicationController
  before_action :set_merchant, only: [:show, :update, :edit, :destroy]

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to "/merchants"
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @merchant.destroy
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
