class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    # 1,　planのインスタンスを生成する
    # ２，from_withにモデル（@plan）を指定する
    # ３，params.require(:plan)でパラメーターで送られてきた値を許可する
    
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      n = Date.today.wday + x
      if n >= 7
        n = n - 7
      else
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :week => wdays[n], :plans => today_plans }
      @week_days.push(days)
    end
  end
end

# index 15行目に曜日を表示させる記述：daysの中にキーを作り、それを取得するday[:month]と同じような書き方
# wdays[n]をそのキーのバリューとして指定してあげる
# →水〜土まで出力できる
# ７を超えた場合の条件分岐を考え出す
# ブロック変数について復習