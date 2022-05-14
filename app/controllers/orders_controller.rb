require_relative '../views/orders_view'
require_relative '../views/sessions_view'
require_relative '../views/customers_view'
require_relative '../views/meals_view'
require_relative '../models/order'

class OrdersController
  def initialize(order_repository, meal_repository, customer_repository, employee_repository)
    @order_repository = order_repository
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @orders_view = OrdersView.new
    @sessions_view = SessionsView.new
    @customers_view = CustomersView.new
    @meals_view = MealsView.new
  end

  def list_undelivered
    # get all undelivered orders from repo
    orders = @order_repository.undelivered_orders 
    # ask the view to display them
    @orders_view.display(orders)
  end

  def add
    # display meals list
    meals = @meal_repository.all
    @meals_view.display(meals)
    # ask for meal index
    meal_index = @meals_view.ask_for("index").to_i - 1
    # get the meal instance from this index
    meal = meals[meal_index]

    # display customers list
    # ask for customer index
    # get the meal instance from this index
    customers = @customer_repository.all
    @customers_view.display(customers)
    customer_index = @customers_view.ask_for("index").to_i - 1
    customer = customers[customer_index]

    # display riders list
    # ask for rider index
    # get the rider instance from this index
    riders = @employee_repository.all_riders
    @sessions_view.display(riders)
    rider_index = @sessions_view.ask_for("index").to_i - 1
    rider = riders[rider_index]

    # create an instance order
    order = Order.new( meal: meal, customer: customer, employee: rider)

    # store in repo
    @order_repository.create(order)
  end
end