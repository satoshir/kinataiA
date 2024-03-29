class BasesController < ApplicationController
  before_action :set_base, only: [:edit, :update, :destroy]
  
  # 管理者かどうか
  before_action :admin_user, only: [:index, :edit, :update, :destroy]
  
  def new
  end
  
  def edit
  end
  
  def index
    @bases = Base.all
  end
  
  
  # 修正
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点を追加しました。'
      redirect_to bases_url
    else
      flash[:danger] = '拠点情報を追加できませんでした。'
       redirect_to bases_url
    end
  end
  
  def update
    # @base_name = @base.base_name
    if @base.update_attributes(update_params)
      flash[:success] = "#{@base.base_name}の拠点情報を更新しました。"
      redirect_to bases_path
    else
      flash[:success] = "#{@base_name}の更新は失敗しました。<br><li>" + @base.errors.full_messages.join("</li><li>")
      redirect_to bases_path
    end
  end
  

  
  def destroy
    @basename = @base.base_name
    @base.destroy
    flash[:success] = "#{@basename}拠点の削除が完了しました。"
    redirect_to bases_path
  end
  
  private
  
    def set_base
      @base = Base.find(params[:id])
    end
  
    def base_params
      params.permit(:base_no, :base_name, :attendance_type)
    end
    
    def update_params
     params.require(:base).permit(:base_no, :base_name, :attendance_type)
    end
end