class ItemsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @items = Item.on_sell.includes([:images]).order(created_at: :desc)
    @ladies_items = Item.where(category_id: 1..199).limit(3)
    @adidas_items = Item.where(brand_id: 3).limit(3)
  end



  def new
    @item = Item.new
    @parents = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @parents << parent
    end
    @item.images.new
    @item.build_brand
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
    @parents = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @parents << parent.name
    end
    @item.images.new
      render :new
    end
  end

  def show
    category_id = Item.find(params[:id]).category_id
    @this_category = Category.find(category_id)
    @parent_category = @this_category.parent unless @this_category == nil
    @grandparent_category = @parent_category.parent unless @parent_category == nil
  end

  def item_purchase
  end

  def get_category_children
    @category_children = Category.find_by(id: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @child_category = Category.find(params[:child_name])
    @category_grandchildren = @child_category.children
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :introduction, :status, :size, :shipping_cost, :shipping_days, :prefecture_id, :category_id, :buyer, brand_attributes: [:id, :name], images_attributes: [:image]).merge(user_id: current_user.id)
  end
end
