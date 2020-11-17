class WeightsController < ApplicationController
  def index
    gon.weight_records = Weight.chart_data(current_user)
    # 記録済みの日付データ
    gon.recorded_dates = current_user.weights.map(&:date)
  end

  def create
    @graph = current_user.weights.build(graph_params)
    date = @graph.date.strftime('%Y/%-m/%-d')
    if @graph.save
      flash[:notice] = "#{date}の記録を追加しました"
    else
      flash[:alert] = 'エラーが発生しました'
    end
    redirect_to root_path
  end

  def update
    @graph = current_user.weights.find_by(date: params[:weight][:date])
    date = @graph.date.strftime('%Y/%-m/%-d')
    if @graph.nil?
      flash[:alert] = 'エラーが発生しました'
    elsif params[:_destroy].nil? && @graph.update(graph_params)
      flash[:notice] = "#{date}の記録を修正しました。"
    elsif params[:_destroy].present? && @graph.destroy
      flash[:alert] = "#{date}の記録を削除しました。"
    else
      flash[:alert] = 'エラーが発生しました'
    end
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:weight).permit(:date, :weight)
  end
end
