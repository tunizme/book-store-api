module Api
  module V1
    class ProductsController < ApplicationController
      include AuthorizeRequest
      skip_before_action :authorize_request, only: [ :index, :show ]
      before_action :authorize_admin, only: [ :create, :update, :destroy ]
      before_action :set_product, only: [ :show, :update, :destroy ]

      def index
        products = Product.page(params[:page]).per(params[:per_page] || 10)
        render json: {
          products: products,
          meta: {
            current_page: products.current_page,
            total_pages: products.total_pages,
            total_count: products.total_count
          }
        }
      end

      def show
        render json: @product
      end

      def create
        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.permit(:name, :description, :price, :stock)
      end

      def authorize_admin
        unless @current_user&.role == "admin"
          render json: { errors: [ "Forbidden: Admin only" ] }, status: :forbidden
        end
      end
    end
  end
end
