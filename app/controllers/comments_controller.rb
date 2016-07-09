class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def create
    @item = Item.find(params[:item_id])
    @comment = @item.comments.create(comments_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to @item
    else
      flash.now[:danger] = "error"
    end
  end

  def destroy
    @item    = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])
    @comment.destroy
    redirect_to item_path(@item)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comments_params
      params.require(:comment).permit(:user_id, :body, :item)
    end
end
