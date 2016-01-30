require 'uri'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.sort_by(&:updated_at).reverse!
    @tags = Part.select("name, count(post_id) as post_count")
      .joins("inner join tags on parts.tag_id = tags.id")
      .group("name")
      .order("post_count DESC")
  end

  # GET /posts/filter/tagname
  def filter
    @tags = Tag.all
    decoded_url = URI.decode params[:name]
    filter_tag = Tag.find_by name: decoded_url
    @posts = filter_tag.posts.sort_by(&:updated_at).reverse!
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
    @post.save_tags @tag_string
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

    @post.update_post @tag_string
    @post.touch(:updated_at)
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
end
