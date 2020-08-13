class NurseTasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @nurse_tasks = NurseTask.where(user: current_user).order(:position)
    @active_task = NurseTask.where(user: current_user, active: true)[0]
    @active_task = @nurse_tasks.where(slot: 8).first if @active_task.nil?
  end

  def sort
    # params[:nurse_tasks].each_with_index do |id, index|
    #   NurseTask.where(id: id).update_all(position: index + 1)
    # end
    params[:nurse_tasks_morning].each_with_index do |id, index|
      NurseTask.where(id: id).update_all(slot: 8, position: index + 1)
    end
    params[:nurse_tasks_afternoon].each_with_index do |id, index|
      NurseTask.where(id: id).update_all(slot: 12, position: index + 1)
    end

    head :ok
  end

  def complete
    @nurse_task = NurseTask.find(params[:format])
    @nurse_task.completed = true
    @nurse_task.save
    redirect_to nurse_tasks_path
  end

  def make_active
    previous_task = NurseTask.where(user: current_user, active: true)[0]
    unless previous_task.nil?
      previous_task.active = false
      previous_task.save
    end
    @nurse_task = NurseTask.find(params[:id])
    @nurse_task.active = true
    @nurse_task.save
    byebug
    redirect_to nurse_tasks_path
  end
end
