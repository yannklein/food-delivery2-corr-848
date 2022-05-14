require 'csv'
require_relative '../models/order'

class OrderRepository
  def initialize(csv_path, meal_repository, customer_repository, employee_repository)
    @csv_path = csv_path

    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository

    @orders = []
    @next_id = 1
    load_csv
  end

  def all
    @orders
  end

  def undelivered_orders
    # @orders.select do |order|
    #   order.delivered? == false
    # end
    @orders.reject { |order| order.delivered? }
  end

  def create(order)
    # order doesn't have an id yet!
    # 1. define an id for the order
    order.id = @next_id
    @next_id += 1
    # 2. store the order into @orders
    @orders << order
    # 3. save all the orders into the CSV file
    save_csv
  end

  def save_csv
    CSV.open(@csv_path, "wb") do |csv|
      csv << ["id", "delivered", "meal_id", "customer_id", "employee_id"]
      @orders.each do |order|
        csv << [order.id, order.delivered?, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_path, headers: :first_row, header_converters: :symbol) do |row|
      # row => {id: "1", delivered: "true", meal_id: "1", customer_id: "1", employee_id: "2" }
      row[:id] = row[:id].to_i
      row[:delivered] = row[:delivered] == "true"
      # get meal ID form CSV
      meal_id = row[:meal_id].to_i
      # find the meal instance corresponding to this ID
      meal = @meal_repository.find(meal_id)
      # store the instance in the :meal key of our row
      row[:meal] = meal

      customer_id = row[:customer_id].to_i
      customer = @customer_repository.find(customer_id)
      row[:customer] = customer

      employee_id = row[:employee_id].to_i
      row[:employee] = @employee_repository.find(employee_id)

      # pass the row hash to our Order.new
      @orders << Order.new(row)
    end
    @next_id = @orders.last.id + 1 if @orders.any?
  end
end