class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups or /groups.json
  def index
    groups = Group.all
    groups = groups.where(name: params[:name]) if params[:name]
    render json: groups.select(:id, :name)
  end

  # GET /groups/1 or /groups/1.json
  def show
    # if groups.select(:id)  # Переделать p-39, p.2 - look @ page 38 & 39 of slides
    render json: groups.select(:id, :name)
    # else
    #   render :status => 404
    # end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit; end

  # POST /groups or /groups.json
  # def create
  #   @group = Group.new(group_params)

  #   respond_to do |format|
  #     if @group.save
  #       format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
  #       format.json { render :show, status: :created, location: @group }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @group.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # POST /groups or /groups.json
  def create
    group = Group.create(group_params)
    render json: { id: group.id, name: group.name }
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
      render status: 204
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_group
  #   @group = Group.find(params[:id])
  # end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name)
  end
end
