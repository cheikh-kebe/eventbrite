class AttendancesController < ApplicationController
  
  before_action :set_attendance, only: %i[ show edit update destroy ]


  # GET /attendances or /attendances.json
  def index
    @attendances = Attendance.all
  end

  # GET /attendances/1 or /attendances/1.json
  def show
    @attendance = Attendance.find(@attendance.id)
  end

  # GET /attendances/new
  def new
    @user = current_user
    @attendance = Attendance.new
    @event = Event.find(params[:event_id])
  end

  # GET /attendances/1/edit
  def edit
    @event = Event.find(params[:event_id])
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)
    @user = current_user
    #_____ script stripe
      
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
    
    @stripe_customer_id = customer.id
      # --- reponse to
        respond_to do |format|
          if @attendance.save 
           format.html { redirect_to event_attendance_path(params[:event_id],@attendance.id), notice: "Attendance was successfully created." }
           format.json { render :show, status: :created, location: @attendance }
           a = Attendance.find(@attendance.id)
           a = a.update(stripe_customer_id: @stripe_customer_id)
         else
           format.html { render :new, status: :unprocessable_entity }
           format.json { render json: @attendance.errors, status: :unprocessable_entity }
         end
        end
        
      end
    
  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.permit(:event_id, :guest_id)
    end
end