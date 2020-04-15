class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json


  def checkInvitedExistance
    @userGroups = User.find(current_user.id).groups
    
    @users = User.where(name: params[:keyword]);
    p @users
      if @users.length != 0
        p "in users......."
        status = "true"
        respond_to do |format|

          format.html # show.html.erb
          format.json { render json: @users }
        end
      else
        @users = Group.where(name: params[:keyword])
          if @users.length != 0
            flag = 0
            @users.each do |group|
              if @userGroups.ids.include? group.id or group.user_id === current_user.id
                flag = 1
                result = true
                respond_to do |format|

                  format.html # show.html.erb
                  format.json { render json: @users }
                end
              end
            end
            if flag == 0
              @users = []
              # respond_with(@users, :include => :status) 
              respond_to do |format|

                format.html # show.html.erb
                format.json { render json: @users }
              end
            end
          else
            @users = []
            # respond_with(@users, :include => :status)
            respond_to do |format|

              format.html # show.html.erb
              format.json { render json: @users, :include => :status }
            end
          end
      end
    end


  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])#, @order.order_details
  end

  def change_status
    @order = Order.find(params[:id])
    puts(@order)
    @order.status = 'ready'
    @order.save
    redirect_to orders_path
  end

  # GET /orders/new
  def new
    @order = Order.new
    @friends = Friend.new
  end

  # GET /orders/1/edit
  # def edit
  # end

  # POST /orders
  # POST /orders.json
  def create
    p "USERS ARRAY______"
    p params
    @order = Order.new(order_params)
    @order.status = "waiting"
    @order.order_time = DateTime.now
    p params
    #Current User Id
    @order.user_id = current_user.id
    @order.menu_path = params[:order][:menu_path].original_filename
    uploaded_io = params[:order][:menu_path]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @order.save
    redirect_to action: :index

    # respond_to do |format|
    #   if @order.save
    #     puts(@order)
    #     format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #     format.json { render :show, status: :created, location: @order }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    # respond_to do |format|
    #   if @order.update(order_params)
    #     format.html { redirect_to @order, notice: 'Order was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @order }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # def destroy
  #   @order.destroy
  #   respond_to do |format|
  #     format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # private

  #   Use callbacks to share common setup or constraints between actions.
  #   def set_order
  #     @order = Order.find(params[:id])
  #   end

    # Only allow a list of trusted parameters through.
    # def order_params
    #   params.fetch(:order, {})
    # end

  def order_params
    params.require(:order).permit(:meal, :restaurant, :menu_path)
  end
 end



def freind_params
 params.require(:friend).permit(:friend_id)
end