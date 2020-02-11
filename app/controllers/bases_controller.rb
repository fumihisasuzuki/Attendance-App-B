class BasesController < ApplicationController
  def index
    @bases = Base.all
    @base = Base.new
  end

  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点情報の追加に成功しました。'
      redirect_to bases_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  

  private

    def base_params
      params.require(:base).permit(:name, :place_type_status)
    end

end
