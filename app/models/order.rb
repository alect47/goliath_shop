class Order <ApplicationRecord

  validates_presence_of :status
  belongs_to :user
  belongs_to :address
  has_many :item_orders, dependent: :destroy
  has_many :items, through: :item_orders

  enum status: %w(pending packaged shipped cancelled)

  def pending_order?
    status == "pending"
  end

  def unused_addresses(address)
    user.addresses.where.not(id: address)
  end

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def packaged
    self.status = 1
    self.save
  end

  def shipped
    self.status = 2
    self.save
  end

  def self.sort_orders
    order(status: :asc)
  end

  def all_item_orders_fulfilled?
    self.item_orders.pluck(:status).all? { |status| status == "fulfilled"}
  end

  def show_order(id)
      self.item_orders.select("item_orders.*").where("merchant_id = #{id}")
  end

end
