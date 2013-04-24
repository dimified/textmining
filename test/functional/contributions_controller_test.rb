require 'test_helper'

class ContributionsControllerTest < ActionController::TestCase
  setup do
    @contribution = contributions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contributions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contribution" do
    assert_difference('Contribution.count') do
      post :create, contribution: { challenge: @contribution.challenge, contribution_id: @contribution.contribution_id, create_date: @contribution.create_date, description: @contribution.description, questions: @contribution.questions, title: @contribution.title, user: @contribution.user, views: @contribution.views, votes: @contribution.votes }
    end

    assert_redirected_to contribution_path(assigns(:contribution))
  end

  test "should show contribution" do
    get :show, id: @contribution
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contribution
    assert_response :success
  end

  test "should update contribution" do
    put :update, id: @contribution, contribution: { challenge: @contribution.challenge, contribution_id: @contribution.contribution_id, create_date: @contribution.create_date, description: @contribution.description, questions: @contribution.questions, title: @contribution.title, user: @contribution.user, views: @contribution.views, votes: @contribution.votes }
    assert_redirected_to contribution_path(assigns(:contribution))
  end

  test "should destroy contribution" do
    assert_difference('Contribution.count', -1) do
      delete :destroy, id: @contribution
    end

    assert_redirected_to contributions_path
  end
end
