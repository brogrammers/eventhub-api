class OfferTypesController < ApplicationController
  # GET /offer_types
  # GET /offer_types.json
  def index
    @offer_types = OfferType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offer_types }
    end
  end

  # GET /offer_types/1
  # GET /offer_types/1.json
  def show
    @offer_type = OfferType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer_type }
    end
  end

  # GET /offer_types/new
  # GET /offer_types/new.json
  def new
    @offer_type = OfferType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer_type }
    end
  end

  # GET /offer_types/1/edit
  def edit
    @offer_type = OfferType.find(params[:id])
  end

  # POST /offer_types
  # POST /offer_types.json
  def create
    @offer_type = OfferType.new(params[:offer_type])

    respond_to do |format|
      if @offer_type.save
        format.html { redirect_to @offer_type, notice: 'Offer type was successfully created.' }
        format.json { render json: @offer_type, status: :created, location: @offer_type }
      else
        format.html { render action: "new" }
        format.json { render json: @offer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offer_types/1
  # PUT /offer_types/1.json
  def update
    @offer_type = OfferType.find(params[:id])

    respond_to do |format|
      if @offer_type.update_attributes(params[:offer_type])
        format.html { redirect_to @offer_type, notice: 'Offer type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_types/1
  # DELETE /offer_types/1.json
  def destroy
    @offer_type = OfferType.find(params[:id])
    @offer_type.destroy

    respond_to do |format|
      format.html { redirect_to offer_types_url }
      format.json { head :no_content }
    end
  end
end
