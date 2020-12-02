class FunctionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_function, only: %i(index show edit update update_state)

  def index
    @functions = Function.all
    @sort = @functions.ransack(params[:q])
    @sort_functions = @sort.result
  end

  def new
    @function = Function.new
  end
  
  def show
  end

  def create
    @function = Function.create function_params
    set_state(@function,@function.aasm_state)
  end 

  def edit 
  end 
  
  def update
    @function.update function_params
    redirect_to @function.project
  end

  def update_state
    set_state(@function, params[:state].to_sym)
    UserMailer.send_status_changed_email(@function).deliver
  end

  def function_params
    params.require(:function).permit(:title, :description, :start_at, :end_at, :project_id, :aasm_state, user_list: [], tag_list: [])
  end
  
  def load_function
    @function = Function.find_by(id: params[:id])
  end
  
  def set_state(f, state)
    f.aasm_state = state
    case state
    when :to_do
      then 
      f[:end_updated_at] = f[:end_at]
      f[:feedback_updated_at] = f[:end_at]
      f[:complete_updated_at] = f[:end_at]
      f[:in_progress_updated_at] = f[:end_at]
      f[:to_do_updated_at] = f[:start_at]
    when :in_progress
      then 
      f[:end_updated_at] = f[:end_at]
      f[:feedback_updated_at] = f[:end_at]
      f[:complete_updated_at] = f[:end_at]
      f[:in_progress_updated_at] = f[:start_at]
      f[:to_do_updated_at] = f[:start_at]
    when :complete
      then 
      f[:end_updated_at] = f[:end_at]
      f[:feedback_updated_at] = f[:end_at]
      f[:complete_updated_at] = f[:start_at]
      f[:in_progress_updated_at] = f[:start_at]
      f[:to_do_updated_at] = f[:start_at]
    when :feedback
      then 
      f[:end_updated_at] = f[:end_at]
      f[:feedback_updated_at] = f[:start_at]
      f[:complete_updated_at] = f[:start_at]
      f[:in_progress_updated_at] = f[:start_at]
      f[:to_do_updated_at] = f[:start_at]
    else
      f[:end_updated_at] = f[:start_at]
      f[:feedback_updated_at] = f[:start_at]
      f[:complete_updated_at] = f[:start_at]
      f[:in_progress_updated_at] = f[:start_at]
      f[:to_do_updated_at] = f[:start_at]
    end
    f.save
  end
end