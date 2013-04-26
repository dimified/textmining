class TermMatricesController < ApplicationController
  # GET /term_matrices
  # GET /term_matrices.json
  def index
    @term_matrices = TermMatrix.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @term_matrices }
    end
  end

  # GET /term_matrices/1
  # GET /term_matrices/1.json
  def show
    @term_matrix = TermMatrix.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term_matrix }
    end
  end

  # GET /term_matrices/new
  # GET /term_matrices/new.json
  def new
    @term_matrix = TermMatrix.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term_matrix }
    end
  end

  # GET /term_matrices/1/edit
  def edit
    @term_matrix = TermMatrix.find(params[:id])
  end

  # POST /term_matrices
  # POST /term_matrices.json
  def create
    @term_matrix = TermMatrix.new(params[:term_matrix])

    respond_to do |format|
      if @term_matrix.save
        format.html { redirect_to @term_matrix, notice: 'Term matrix was successfully created.' }
        format.json { render json: @term_matrix, status: :created, location: @term_matrix }
      else
        format.html { render action: "new" }
        format.json { render json: @term_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /term_matrices/1
  # PUT /term_matrices/1.json
  def update
    @term_matrix = TermMatrix.find(params[:id])

    respond_to do |format|
      if @term_matrix.update_attributes(params[:term_matrix])
        format.html { redirect_to @term_matrix, notice: 'Term matrix was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @term_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /term_matrices/1
  # DELETE /term_matrices/1.json
  def destroy
    @term_matrix = TermMatrix.find(params[:id])
    @term_matrix.destroy

    respond_to do |format|
      format.html { redirect_to term_matrices_url }
      format.json { head :no_content }
    end
  end
end
