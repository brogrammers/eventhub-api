class IdentitiesController < ApplicationController
  # GET /identities
  # GET /identities.json
  def index
    @identities = Identity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @identities }
    end
  end

  # GET /identities/1
  # GET /identities/1.json
  def show
    @identity = Identity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @identity }
    end
  end

  # GET /identities/new
  # GET /identities/new.json
  def new
    @identity = Identity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @identity }
    end
  end

  # GET /identities/1/edit
  def edit
    @identity = Identity.find(params[:id])
  end

  # POST /identities
  # POST /identities.json
  def create
    @identity = Identity.new(params[:identity])

    respond_to do |format|
      if @identity.save
        format.html { redirect_to @identity, notice: 'Identity was successfully created.' }
        format.json { render json: @identity, status: :created, location: @identity }
      else
        format.html { render action: "new" }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /identities/1
  # PUT /identities/1.json
  def update
    @identity = Identity.find(params[:id])

    respond_to do |format|
      if @identity.update_attributes(params[:identity])
        format.html { redirect_to @identity, notice: 'Identity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identities/1
  # DELETE /identities/1.json
  def destroy
    @identity = Identity.find(params[:id])
    @identity.destroy

    respond_to do |format|
      format.html { redirect_to identities_url }
      format.json { head :no_content }
    end
  end
end
