class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    @books = @user.books
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def posts_on_date
    @user = User.find(params[:user_id])# リクエストの中からユーザーIDを取得し、データベースからユーザー情報を取得
    @books = @user.books.where(created_at: params[:created_at].to_date.all_day) # ユーザーが指定した日に投稿した本（books）をデータベースから検索
    render :posts_on_date_form# 検索結果を表示するためのビュー（posts_on_date_form）にデータを送る
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
