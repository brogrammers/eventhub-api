class CoreUsersController < ApplicationController

  def index
    @users = CoreUser.all
  end

  def show
    @user = CoreUser.find(params[:id])
  end

  def create
    @user = CoreUser.new(params[:user])

    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: :created, location: @user }
        format.xml { render xml: @user, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = CoreUser.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = CoreUser.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end
end
