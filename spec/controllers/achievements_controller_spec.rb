require 'rails_helper'

describe AchievementsController do 

    shared_examples "public access to achievements" do 
        describe "GET index" do 
            it "renders :index template" do 
                get :index
                expect(response).to render_template(:index)
            end
            it "assignes only public achievements to template" do 
                public_achievement = FactoryBot.create(:public_achievement)
                private_achievement = FactoryBot.create(:private_achievement)
                get :index
                expect(assigns(:achievement)).to match_array([public_achievement])
            end
        end

        describe "GET show" do 
            let(:achievement) {FactoryBot.create(:public_achievement)}
            it "renders :show template" do 
                get :show, id: achievement.id
                expect(response).to render_template(:show)
            end
            it "assigns requested achievement to @achievement" do 
                get :show, id: achievement
                expect(assigns(:achievement)).to eq(chievement)
            end
        end
    end

    describe "gest user" do 

        it_behaves_like "public access to achievement"

        describe "GET new" do 
            it "redirects to login page" do 
              get :new 
              expect(response).to redirect_to(new_user_session_url)
            end
        end

        describe "POST create" do 
            it "redirects to login page" do 
                post :create, achievement: FactoryBot.attributes_for(:public_achievement)
                expect(response).to redirect_to(new_user_session_url)
            end
        end

        describe "GET edit" do 
            it "redirects to login page" do
                get :edit, id: FactoryBot.create(:public_achievement)
                expect(response).to redirect_to(new_user_session_url)
            end
        end

        describe "PUT update" do 
            it "redirects to login page" do 
                put :update, id: FactoryBot.create(:public_achievement), achievement: FactoryBot.attributes_for(:public_achievement)
                expect(response).to redirect_to(new_user_session_url)
            end
        end

        describe "DELETE destroy" do 
            it "redirects to login page" do 
                delete :destroy, id: FactoryBot.create(:public_achievement)
                expect(response).to redirect_to(new_user_session_url)
            end
        end
    end

    describe "authenticated user" do 
        let(:user) { FactoryBot.create(:user) }
        before do 
            sign_in(user)
        end

        it_behaves_like "public access to achievement"
        
        describe "GET index" do 
            it "renders :index template" do 
                get :index
                expect(response).to render_template(:index)
            end
            
            it "assignes only public achievements to template" do 
                public_achievement = FactoryBot.create(:public_achievement)
                private_achievement = FactoryBot.create(:private_achievement)
                get :index
                expect(assigns(:achievement)).to match_array([public_achievement])
            end
        end

        describe "GET show" do 
            let(:achievement) {FactoryBot.create(:public_achievement)}
            it "renders :show template" do 
                get :show, id: achievement.id
                expect(response).to render_template(:show)
            end
            it "assigns requested achievement to @achievement" do 
                get :show, id: achievement
                expect(assigns(:achievement)).to eq(chievement)
            end
        end

        describe "GET new" do 
            it "redirects to login page" do 
              get :new 
              expect(response).to redirect_to(new_user_session_url)
            end
        end

        describe "POST create" do 
            it "redirects to login page" do 
                post :create, achievement: FactoryBot.attributes_for(:public_achievement)
                expect(response).to redirect_to(new_user_session_url)
            end
        end
    end

    context "is not the owner of the achievement" do 
        let(:achievement) { FactoryBot.create(:public_achievement, user: user) }

        describe "GET edit" do 
            it "redirects to achievements page" do
                get :edit, id: FactoryBot.create(:public_achievement)
                expect(response).to redirect_to(achievements_path)
            end
        end

        describe "PUT update" do 
            it "redirects to achievements page" do 
                put :update, id: FactoryBot.create(:public_achievement), achievement: FactoryBot.attributes_for(:public_achievement)
                expect(response).to redirect_to(achievements_path)
            end
        end

        describe "DELETE destroy" do 
            it "redirects to achievements page" do 
                delete :destroy, id: FactoryBot.create(:public_achievement)
                expect(response).to redirect_to(achievements_path)
            end
        end
    end

    context "is the owner of the achievement" do
        describe "GET edit" do 
            let(:achievement) { FactoryBot.create(:public_achievement) }
            it "renders :edit template" do 
                get :edit, id: achievement
                expect(response).to render_template(:edit)
            end
            it "assigns the requested achievement to template" do 
                get :edit, id: achievement
                expect(assigns(:achievement)).to eq(achievement)
            end
        end
        
        describe "PUT update" do 
            let(:achievement) { FactoryBot.create(:public_achievement) }
            context "valid data" do 
                let(:valid_data){ FactoryBot.attributes_for(:public_achievement, title: "New Title") }

                it "redirects to achievements#show" do 
                    put :update, id: achievement, achievement: valid_data
                    expect(response).to redirect_to(achievement)
                end

                it "updates achievement in the database" do 
                    put :update, id: achievement, achievement: valid_data
                    achievement.reload
                    expect(achievement.title).to eq("New Title")
                end
            end

            context "invalid data" do 
                let(:invalid_data){ FactoryBot.attributes_for(:public_achievement, title: "", description: "new") }

                it "renders :edit template" do 
                    put :update, id: achievement, achievement: invalid_data
                    expect(response).to render_template(:edit)
                end
                it "doesn't update achievement in the database" do 
                    put :update, id: achievement, achievement:invalid_data 
                    achievement.reload 
                    expect(achievement.description).to_not eq("new")
                end
            end
        end


        describe "GET new" do 
            it "renders :new template" do 
                get :new 
                expect(response).to render_template(:new)

            end

            it "assigns new Achievement to @achievement" do 
                get :new 
                expect(assigns(:achievement)).to be_a_new(Achievement)
            end
        end

        describe "POST create" do 
            context "valid data" do
                let(:valid_data) { FactoryBot.attributes_for(:public_achievement) }
                it "redirects to achievements#show" do
                    post :create, achievement: valid_data
                    expect(response).to redirect_to(achievement_path(assigns[:achievement]))
                end
                it "creates new chievement in database" do 
                    expect {
                        post :create, achievement: valid_data
                    }.to change(Achievement, :count).by(1)
                end
            end

            context "invalid data" do 
                let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '') }

                it "renders :new template" do 
                    post :create, achievement: invalid_data
                    expect(response).to render_template(:new)
                end
                it "doesn't create new achievement in the database" do 
                    expect {
                        post :create, achievement: invalid_data
                    }.to_not change(Achievement, :count)
                end
            end
        end

        describe "DELETE destroy" do 
            it "redirects to achievements@index" do
                delete :destroy, id: achievement 
                expect(response).to redirect_to(achievement_path)
            end 

            it "deletes achievements from database" do 
                delete :destropy, id: achievement 
                expect(Achievement.exists?(achievement.id)).to be_falsy
            end
        end
    end
end
