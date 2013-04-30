require 'test_helper'

class DocumentTermMatricesControllerTest < ActionController::TestCase
  setup do
    @document_term_matrix = document_term_matrices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_term_matrices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_term_matrix" do
    assert_difference('DocumentTermMatrix.count') do
      post :create, document_term_matrix: {  }
    end

    assert_redirected_to document_term_matrix_path(assigns(:document_term_matrix))
  end

  test "should show document_term_matrix" do
    get :show, id: @document_term_matrix
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @document_term_matrix
    assert_response :success
  end

  test "should update document_term_matrix" do
    put :update, id: @document_term_matrix, document_term_matrix: {  }
    assert_redirected_to document_term_matrix_path(assigns(:document_term_matrix))
  end

  test "should destroy document_term_matrix" do
    assert_difference('DocumentTermMatrix.count', -1) do
      delete :destroy, id: @document_term_matrix
    end

    assert_redirected_to document_term_matrices_path
  end
end
