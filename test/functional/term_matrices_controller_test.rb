require 'test_helper'

class TermMatricesControllerTest < ActionController::TestCase
  setup do
    @term_matrix = term_matrices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:term_matrices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create term_matrix" do
    assert_difference('TermMatrix.count') do
      post :create, term_matrix: { term: @term_matrix.term, term_id: @term_matrix.term_id }
    end

    assert_redirected_to term_matrix_path(assigns(:term_matrix))
  end

  test "should show term_matrix" do
    get :show, id: @term_matrix
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @term_matrix
    assert_response :success
  end

  test "should update term_matrix" do
    put :update, id: @term_matrix, term_matrix: { term: @term_matrix.term, term_id: @term_matrix.term_id }
    assert_redirected_to term_matrix_path(assigns(:term_matrix))
  end

  test "should destroy term_matrix" do
    assert_difference('TermMatrix.count', -1) do
      delete :destroy, id: @term_matrix
    end

    assert_redirected_to term_matrices_path
  end
end
