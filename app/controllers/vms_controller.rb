class VmsController < ApplicationController
  # GET /vms or /vms.json
  def index
    @vms = Vm.all
    render json: @vms
  end

  # GET /vms/1 or /vms/1.json
  def show; end

  # GET /vms/new
  def new
    @vm = Vm.new
  end

  # GET /vms/1/edit
  def edit; end

  # POST /vms or /vms.json
  def create
    @Vm = Vm.new(vm_params)

    respond_to do |format|
      if @vm.save
        format.html { redirect_to vm_url(@vm), notice: 'Vm was successfully created.' }
        format.json { render :show, status: :created, location: @vm }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vms/1 or /vms/1.json
  def update
    respond_to do |format|
      if @vm.update(vm_params)
        format.html { redirect_to vm_url(@vm), notice: 'vm was successfully updated.' }
        format.json { render :show, status: :ok, location: @vm }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vms/1 or /vms/1.json

  def destroy
    @vm.destroy

    respond_to do |format|
      format.html { redirect_to vms_url, notice: 'vm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vm
    @vm = vm.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def vm_params
    params.require(:vm).permit(:name, :status, :cost)
  end
end
