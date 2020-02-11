class BasesController < ApplicationController
  before_action :set_base, only: [:edit, :update, :destroy]
  
  def index
    @bases = Base.all
    @base = Base.new
  end

  def new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点情報の追加に成功しました。'
    else
      flash[:danger] = '拠点情報の追加に失敗しました。'
    end
    redirect_to bases_path
  end
  
  def edit
  end
  
  def update
    name_edited = @base.name
    if @base.update_attributes(base_params)
      flash[:success] = @base.name + 'の情報を修正しました。'
    else
      flash[:danger] = name_edited + 'の情報修正に失敗しました。'
    end
    redirect_to bases_path
  end
  
  def destroy
    name_destroyed = @base.name
    @base.destroy
    flash[:success] = name_destroyed + 'を削除しました。'
    redirect_to bases_path
  end
  

  private
  
    # beforeフィルター
  
    # 対象の拠点情報を取得します。
    def set_base
      @base = Base.find(params[:id])
    end


    # strong parameter
    def base_params
      params.require(:base).permit(:name, :place_type_status)
    end

end
