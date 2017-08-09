class PostsController < ApplicationController
  before_action :find_post, only: [:show, :upvote]
  
  before_action :check_signed_in, except: :show
  def show
    
  end
  
  def index
    @posts = Post.all.order("created_at DESC")
  end
  

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  def edit
  end
  
  def upvote
    @post.upvote_by current_user
    redirect_to :back
  end

  private
  def post_params
    params.require(:post).permit(:image, :description)
  end

  def check_signed_in
    redirect_to signin_path unless signed_in?
  end
  
  def find_post
    @post = Post.find(params[:id])
  end

end