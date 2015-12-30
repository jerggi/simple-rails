class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @tags = Tag.all

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    post = Post.find params[:id]
    @tag_string = ''
    post.tags.each do |tag|
      @tag_string += tag[:name] + ', '
    end
    @tag_string = @tag_string[0...-2]
  end

  def filter
    @tags = Tag.all
    filter_tag = Tag.find_by name: params[:name]
    @posts = filter_tag.posts
  end

  # GET /posts/new
  def new
    @post = Post.new
    @tag = Tag.new
  end

  # GET /posts/1/edit
  def edit
    post = Post.find params[:id]
    @tag_string = ''
    post.tags.each do |tag|
      @tag_string += tag[:name] + ', '
    end
    @tag_string = @tag_string[0...-2]
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @tag_string = params[:post_tags]


    tags = params[:post_tags].split(',')
    tags.each do |t|
      t = remove_spaces t
      next if t.length == 0
      found_tag = Tag.find_by name: t
      if found_tag.nil?
        @tag = Tag.create(name: t)
        @post.tags << [@tag]
      else
        found_tag.posts << [@post]
      end
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        remove_empty_tags
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post.tags.clear
    @tag_string = params[:post_tags]
    remove_empty_tags
    tags = params[:post_tags].split(',')
    tags.each do |t|
      t = remove_spaces t
      next if t.length == 0
      found_tag = Tag.find_by name: t
      if found_tag.nil?
        @tag = Tag.create(name: t)
        @post.tags << [@tag]
      else
        found_tag.posts << [@post]
      end
    end
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_url, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        remove_empty_tags
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    remove_empty_tags

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:author, :title, :body)
    end

    def remove_empty_tags
      tags = Tag.all
      tags.each do |t|
        posts = t.posts
        t.destroy if posts.empty?
      end
    end

    def remove_spaces(t)
      loop do
          break if t.length == 0 || t[0] != ' '
          t[0] = ''
      end
      loop do
          break if t.length == 0 || t[t.length-1] != ' '
          t[t.length-1] = ''
      end
      t
    end

end
