class ProjectsController < ApplicationController
  before_action :load_project, only: %i(show)
  before_action :check_owner, only: %i(show)

  def index 
    @projects = Project.all
  end 
  
  def show
    # 채팅방 로드
    session[:conversations] ||= []
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:project, :messages).find(session[:conversations])

    @functions = @project.functions.page(params[:page]).per(10)
    @function_per_user = []
    @project.users.each do |user|
      @function_per_user << [user.name, @project.functions.tagged_with(user.id).count ]
    end

    @sort = @functions.ransack(params[:q])
    @sort_functions = @sort.result.order(id: :asc)
    @time_hash = Hash.new
    @time_arr = []
    count = [@project.functions.all.count,0,0,0,0]
    @state_arr = [:to_do_updated_at,:in_progress_updated_at,:complete_updated_at,:feedback_updated_at,:end_updated_at]
    hash_n= Hash[*@state_arr.zip(count).flatten]
    @date_arr = (1.month.ago.to_date..Date.today).to_a
    (1.month.ago.to_date..Date.today).to_a.each do |time|
      @time_arr.push(calculate_count(@project.functions,hash_n,time.to_time))
    end
    @result = Hash.new
    @temp = []
    @res = []
    # @date_arr.each do |da, index|
    #   @time_arr.pluck(sa)
    #   # @result[da] = @time_arr.pluck(sa)
    # end
    # @date_arr.each do |da|   
    @state_arr.each do |sa|
        # @temp.push([sa,@time_arr.pluck(sa)[@date_arr.index(da)]])
        
      @result[:name] = sa
      @result[:data] = Hash[*@date_arr.zip(@time_arr.pluck(sa)).flatten]
      @res.push(@result.clone)
    end
      # @result[:data] = @temp.clone
      # @temp = []
      # @result.push({ sa => @date_arr.zip(@time_arr.pluck(sa)) })
    # end
    
    # @result = [*@date_arr.zip(@time_arr.pluck(:to_do_updated_at))]
      # @time_hash[time] = calculate_count(@project.functions,hash_n,time.to_time).to_a
    # # end
    # @result = Hash.new
    # @state_arr.each do |sa|
    #   @result[sa] = [*@date_arr.zip(@time_arr.pluck(sa))]
    #   @result[sa] = 
    # end
  
    # @time_hash = calculate_count(@project.functions,hash_n)
    # @xth = @time_hash.keys
    # @yth = @time_hash.values
  end

  private 

  def load_project
    @project = Project.find_by(id: params[:id])
  end 

  def check_owner
    unless @project.users.include?(current_user)
      redirect_to root_path, alert: "접근권한이 없습니다"
    end
  end

  def calculate_count(functions,h,date)
    new_hash = Hash.new
    cnt = 0
    cnt2 = 0
    functions.each do |function|
      @state_arr.each do |state_updated_at|
        if (function[state_updated_at] - date).to_i == 0 
          case state_updated_at
          when :to_do_updated_at
            then  
          else
            h[state_updated_at] += 1 
            h[@state_arr[@state_arr.index(state_updated_at)-1]] -= 1
            cnt += 1
          end
        end
      end
      new_hash = h.clone
    end
    return new_hash
  end

  # def calculate_count(functions,state_updated_at, date)
  #   count = 0
  #   functions.all.each do |function|
  #     if function.state_updated_at - date == 0 
  #       if state_updated_at == to_do_updated_at
  #         count -= 1 
  #       else
  #         count += 1
  #       end
  #     end
  #   end
  #   return count
  # end

end
