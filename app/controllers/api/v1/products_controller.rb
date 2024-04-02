class Api::V1::ProductsController < ApplicationController
  before_action :check_login, only: %i[create]

  def index
    render json: Product.all
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { erros: product.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
