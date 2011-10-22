class BriefCommentsController < ApplicationController
  # GET /brief_comments
  # GET /brief_comments.json
  def index
    @brief_comments = BriefComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brief_comments }
    end
  end

  # GET /brief_comments/1
  # GET /brief_comments/1.json
  def show
    @brief_comment = BriefComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brief_comment }
    end
  end

  # GET /brief_comments/new
  # GET /brief_comments/new.json
  def new
    @brief_comment = BriefComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brief_comment }
    end
  end

  # GET /brief_comments/1/edit
  def edit
    @brief_comment = BriefComment.find(params[:id])
  end

  # POST /brief_comments
  # POST /brief_comments.json
  def create
    @brief_comment = BriefComment.new(params[:brief_comment])

    respond_to do |format|
      if @brief_comment.save
        format.html { redirect_to @brief_comment, notice: 'Brief comment was successfully created.' }
        format.json { render json: @brief_comment, status: :created, location: @brief_comment }
      else
        format.html { render action: "new" }
        format.json { render json: @brief_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brief_comments/1
  # PUT /brief_comments/1.json
  def update
    @brief_comment = BriefComment.find(params[:id])

    respond_to do |format|
      if @brief_comment.update_attributes(params[:brief_comment])
        format.html { redirect_to @brief_comment, notice: 'Brief comment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @brief_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brief_comments/1
  # DELETE /brief_comments/1.json
  def destroy
    @brief_comment = BriefComment.find(params[:id])
    @brief_comment.destroy

    respond_to do |format|
      format.html { redirect_to brief_comments_url }
      format.json { head :ok }
    end
  end
end
