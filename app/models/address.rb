class Address < ApplicationRecord

  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :nickname, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates_length_of :zip, :is => 5
  validates_numericality_of :zip

  def no_shipped_orders?
    orders.where(status: "shipped").empty?
  end
end
