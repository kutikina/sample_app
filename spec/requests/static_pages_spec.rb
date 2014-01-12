require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
	
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should have_title (full_title(''))}
    it { should_not have_title('| Home')}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should show the user's feed count" do
        should have_content('2 microposts')
      end

      let(:user1post) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user1post, content: "Ipsum")
      end

      it "should should pluralise the user's post count" do
        users = [user, user1post]
        users.each do |user|
          if user.microposts.count == 1
            should have_content('micropost')
          else 
            should have_content('microposts')
          end
        end
      end
    end
    describe "pagination of user's posts" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        31.times {FactoryGirl.create(:micropost, user: user, content: "Lorem") }
        sign_in user
        visit root_path
      end

      it "should paginate the users posts" do
        should have_selector('div.pagination')
      end
    end

    describe "micropost delete links" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wronguser) { FactoryGirl.create(:user) }
      let!(:wrongpost) { FactoryGirl.create(:micropost, user: wronguser) }
      before do
        sign_in user
        visit root_path
      end

      it "should not have delete link for wrong user's post" do
        should_not have_link('delete')
      end
    end      
  end


  describe "Help page" do
    before { visit help_path }  
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }    

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path } 
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }     

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' } 

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_selector('h1', text: 'Sign up')
    click_link "sample app"
    expect(page).to have_selector('h1', text: 'Welcome to the Sample App' )
  end
end