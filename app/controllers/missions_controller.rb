class MissionsController < ApplicationController
  before_action :set_mission, only: [:edit, :update, :destroy]

  def index
    if current_plan
      @missions = current_plan.missions
    else
      flash[:info] = "É necessário selecionar um plano primeiro"
      redirect_to plans_path
    end
  end

  def new
    @mission = Mission.new
  end

  def edit
    render :edit
  end

  def update
    if @mission.update mission_params
      flash[:notice] = "Missão atualizada com sucesso!"
      redirect_to root_url
    else
      render :edit
    end
  end

  def update_selected_mission
    if (plan_to_update = current_plan)
      plan_to_update.update_attribute(:selected_mission, params[:format])
      flash[:notice] = "Missão selecionada foi atualizada com sucesso!"
      redirect_back(fallback_location: missions_path)
    else
      flash[:notice] = "Missão selecionada não pode ser atualizada"
    end
  end

  def create
    @mission = Mission.new mission_params
    @mission.plan_id = current_user.selected_plan

    if @mission.save
      flash[:notice] = "Missão criada com sucesso"
      redirect_to missions_path
    else
      render :new
    end
  end

  def destroy
    @mission.destroy
    flash[:info] = "Missão excluida"
    redirect_to missions_url
  end

  private

  def mission_params
    mission = params.require(:mission).permit(:purpose_of_life, :who_am_i, :why_exist, :plan_id)
  end

  def set_mission
    @mission = Mission.find(params[:id])
  end
end