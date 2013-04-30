class DocumentTermMatricesController < ApplicationController
  # GET /document_term_matrices
  # GET /document_term_matrices.json
  def index
    @document_term_matrices = DocumentTermMatrix.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @document_term_matrices }
    end
  end

  # GET /document_term_matrices/1
  # GET /document_term_matrices/1.json
  def show
    @document_term_matrix = DocumentTermMatrix.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document_term_matrix }
    end
  end

  # GET /document_term_matrices/new
  # GET /document_term_matrices/new.json
  def new
    @document_term_matrix = DocumentTermMatrix.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document_term_matrix }
    end
  end

  # GET /document_term_matrices/1/edit
  def edit
    @document_term_matrix = DocumentTermMatrix.find(params[:id])
  end

  # POST /document_term_matrices
  # POST /document_term_matrices.json
  def create
    @document_term_matrix = DocumentTermMatrix.new(params[:document_term_matrix])

    respond_to do |format|
      if @document_term_matrix.save
        format.html { redirect_to @document_term_matrix, notice: 'Document term matrix was successfully created.' }
        format.json { render json: @document_term_matrix, status: :created, location: @document_term_matrix }
      else
        format.html { render action: "new" }
        format.json { render json: @document_term_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /document_term_matrices/1
  # PUT /document_term_matrices/1.json
  def update
    @document_term_matrix = DocumentTermMatrix.find(params[:id])

    respond_to do |format|
      if @document_term_matrix.update_attributes(params[:document_term_matrix])
        format.html { redirect_to @document_term_matrix, notice: 'Document term matrix was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document_term_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_term_matrices/1
  # DELETE /document_term_matrices/1.json
  def destroy
    @document_term_matrix = DocumentTermMatrix.find(params[:id])
    @document_term_matrix.destroy

    respond_to do |format|
      format.html { redirect_to document_term_matrices_url }
      format.json { head :no_content }
    end
  end

  def term_matrix
    @term_matrix = DocumentTermMatrix.new
    @term_vectors = @term_matrix.term_vectors
    
    respond_to do |format|
      format.html
      format.json { render json: @matrices }
    end
  end

  def document_matrix
    @document_matrix = DocumentTermMatrix.new
    @document_vectors = @document_matrix.document_vectors

    respond_to do |format|
      format.html
      format.json { render json: @matrices }
    end
  end
end
