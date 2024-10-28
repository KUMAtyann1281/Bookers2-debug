class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new = Book.new
    @book_comment = BookComment.new
    @book_tags = @book.tags
    @book_detail = Book.find(params[:id])
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.read_counts.create(book_id: @book_detail.id)
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
      }
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
    @book = Book.new
    @tag_list=Tag.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list=params[:book][:name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      flash.discard(:notice)
      @books = Book.all
      @user_info = current_user
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list=@post.tags.pluck(:name).join(',')
  end

  def update
    @book = Book.find(params[:id])
    @tag_list=params[:post][:name].split(',')
    if @book.update(book_params)
       @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book. destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star)
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user.id == current_user.id
      redirect_to books_path
    end
  end
end
