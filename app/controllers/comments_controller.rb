class CommentsController < ApplicationController

  before_action :load_commentable
  before_action :authenticate_user!, except: [:index]

  def index
    @comments = @commentable.comments.page(params[:page])
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end


  private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end
