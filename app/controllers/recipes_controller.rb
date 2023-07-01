class RecipesController < ApplicationController
    def index
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
        recipes = Recipe.all
        render json: recipes
    end
    
    def create
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
        user = User.find_by(id: params[:user_id])
        recipe = Recipe.create(recipe_params)
        if recipe.valid?
            session[:user_id] = user.id
          render json: recipe, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :image_url, :bio)
    end
    
end
