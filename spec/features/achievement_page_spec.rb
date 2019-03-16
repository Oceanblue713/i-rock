require "rails_helper"

feature 'achievement page' do 
    scenario 'achievement public page' do 
        achievement = FactoryBot.create(:achievement, title: "Just did it")
        visit("/achievements/#{achievement.id}")

        expect(page).to have_content("Just did it")
    end

    scenario "render markdown description" do 
        Achievement = FactoryBot.create(:achievement, description: "That *was* hard")
        visit("/achievements/#{achievement.id}")

        expect(page).to have_content('em', text: 'was')
    end
end

