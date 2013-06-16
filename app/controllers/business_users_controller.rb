class BusinessUsersController < ApplicationController
  # GET /business_members
  # GET /business_members.json
  def index
    @business_members = BusinessUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @business_members }
    end
  end

  # GET /business_members/1
  # GET /business_members/1.json
  def show
    @business_member = BusinessUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @business_member }
    end
  end

  # GET /business_members/new
  # GET /business_members/new.json
  def new
    @business_member = BusinessUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @business_member }
    end
  end

  # GET /business_members/1/edit
  def edit
    @business_member = BusinessUser.find(params[:id])
  end

  # POST /business_members
  # POST /business_members.json
  def create
    @business_member = BusinessUser.new(params[:business_member])

    respond_to do |format|
      if @business_member.save
        format.html { redirect_to @business_member, notice: 'Business member was successfully created.' }
        format.json { render json: @business_member, status: :created, location: @business_member }
      else
        format.html { render action: "new" }
        format.json { render json: @business_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /business_members/1
  # PUT /business_members/1.json
  def update
    @business_member = BusinessUser.find(params[:id])

    respond_to do |format|
      if @business_member.update_attributes(params[:business_member])
        format.html { redirect_to @business_member, notice: 'Business member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_members/1
  # DELETE /business_members/1.json
  def destroy
    @business_member = BusinessUser.find(params[:id])
    @business_member.destroy

    respond_to do |format|
      format.html { redirect_to business_members_url }
      format.json { head :no_content }
    end
  end
end
