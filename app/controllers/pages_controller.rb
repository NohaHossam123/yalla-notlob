class PagesController < ApplicationController
  before_action :authenticate_user!


  def index
    if user_signed_in?
      @currentUser = current_user.name
      @orders=[]
      @ordersN= Order.where(user_id: current_user.id )
      @ordersN.each do |order|
        if order.status == "waiting"
            @orders.push("#{order.meal.to_s} on #{order.created_at.to_s}")
          # @orders.push(""+order.meal+" on "+ order.created_at.strftime("%d-%m-%Y"))
        end 
        # @orders.push(order.restaurant)

      end


      

      # redirect_to root_path
    else
      redirect_to new_user_session_path
    end

  end
  def errorPage

  end
end
