class CommentsController < ApplicationController
  
  def create
    @item    = Item.find(params[:item_id])
    @comment = @item.comments.create(comments_params)
    redirect_to item_path(@item)
  end

  def destroy
    @item    = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])
    @comment.destroy
    redirect_to item_path(@item)
  end

  private

  def comments_params
    params.require(:comment).permit(:commenter, :body, :item)
  end
end
