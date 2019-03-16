class AchievementsController < ApplicationController 
    before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
    before_action :owners_only, only: [ :edit, :update, :destroy]

    def index 
        @achievement = Achievement.public_access
    end

    def new 
        @achievement = Achievement.new
    end

    def create 
        @achievement = Achievement.new(achievement_params)
        if @achievement.save 
            redirect_to achievement_url(achievement), notice: "Achievement has been created"
        else 
            render :new
        end
    end

    def edit 
       
    end

    def update 
        if @achievement.update_attributes(achievement_params)
            redirect_to achievement_path(params[:id])
        else   
            render :edit
        end
    end

    def show 
        @achievement = Achievement.find(params[:id])
        @description = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@achievement.description)
    end

    def destroy 
        @achievement.destroy
        redirect_to achievement_path
    end

    private 

    def achievement_params 
        params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured)
    end

    def owners_only 
        @achievement = Achievement.find(params[:id])
        if current_user != @achievement.user 
            redirect_to achievements_path 
        end
    end
end