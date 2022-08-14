class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_basic_info_admin, :working_list, :attendance_log, :csv_export]
  # アクセス先のログインユーザーor上長（管理者も不可）
  before_action :admin_or_correct, only: :show
  # ログイン中かどうか
  before_action :logged_in_user, only: [:edit, :index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_basic_info_admin, :attendance_log, :working_list]
  # アクセス先のログインユーザーかどうか
  before_action :correct_user, only: [:edit, :update, :attendance_log]
  # 管理者かどうか
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info, :edit_basic_info_admin, :working_list]
  # １ヶ月分の勤怠情報を取得
  before_action :set_one_month, only: [:show, :attendance_log, :csv_export]
 


  def basic_info
  end


  
  def bases
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
    # @users = @users.where('name LIKE?', "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @users = User.all
    @worked_sum = @attendances.where.not(started_at: nil).count
    @r_count = Report.where(r_request: @user.name, r_approval: "申請中").count
    @a_count = Attendance.where(c_request: @user.name, c_approval: "申請中").count
    @o_count = Attendance.where(o_request: @user.name, o_approval: "申請中").count
  end
  
  #勤怠修正ログ
  def attendance_log
    @users = User.all
    @attendances = Attendance.where(user_id: @user).where(c_approval: "承認").order(worked_on: "DESC")
    
    if params[:attendance].present?
      unless params[:attendance][:worked_on] == ""
        @search_date = params[:attendance][:worked_on] + "-1"
        @attendances = @attendances.where(started_at: @search_date.in_time_zone.all_year)
                                  .where(started_at: @search_date.in_time_zone.all_month)
        if @attendances.count == 0
          flash.now[:warning] = "承認済みの修正履歴がありません。"
        end
      else
        flash.now[:warning] = "年月を選択してください。"
      end
    end
  end
  
  def csv_export
    respond_to do |format|
      format.html do
          #html用の処理を書く
      end 
      format.csv do
          #csv用の処理を書く
          send_data render_to_string,
          filename: "【勤怠】#{@user.name}_#{@first_day.strftime("%Y-%m")}.csv", type: :csv
      end
    end
  end
  
  def import
    # fileはtmp(temporary)に自動で一時保存される
    if params[:file].presence
      @regist_check = User.import(params[:file])
      
      if @regist_check
        flash[:success] = "CSVファイルのインポートが完了しました。"
      else
        flash[:danger] = "更新できるデータがありませんでした。"
      end
    else
      flash[:danger] = "CSVファイルが選択されていません。"
    end
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end


  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def admin_or_correct
      @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "アクセス出来ません。"
      redirect_to(root_url)
    end
  end
  
  def in_attendance
    @users = User.all
  end
  

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    # beforeフィルター

    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end

    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end

    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
    def notice_overtime
      @notice_user = User.where(id: Attendance.where(o_request: @user.name, o_approval: "申請中").select(:user_id))
    end
  
end