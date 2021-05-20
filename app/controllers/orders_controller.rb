class OrdersController < ApplicationController

  def new
    @user = current_user
    @event = Event.find(params[:event_id])
    @amount = @event.price
    @stripe_amount = (@amount * 100).to_i
  end

  def create
    # Before the rescue, at the beginning of the method
    @attendance = Attendance.new(attendance_params)
    @user = current_user
    @event = Event.find(params[:event_id])
    @amount = @event.price
    @stripe_amount = (@amount * 100).to_i

    begin
      customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
      })  
      charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @stripe_amount,
      description: "Achat d'un produit",
      currency: 'eur',
      })
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_order_path
    end
    # After the rescue, if the payment succeeded
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

  # Only allow a list of trusted parameters through.
    def attendance_params
      params.permit(:stripe_customer_id, :guest_id, :event_id, )
    end
end
