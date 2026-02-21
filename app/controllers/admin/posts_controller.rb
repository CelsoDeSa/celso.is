module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]
    before_action :set_pages, only: [ :new, :edit, :create, :update ]

    def index
      @posts = Post.ordered
    end

    def show
    end

    def new
      @post = Post.new
      @post.published = false
      @post.published_at = Time.current
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to admin_posts_path, notice: "Post was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Post was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Post was successfully deleted."
    end

    private

    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def set_pages
      @pages = Page.categories.ordered
    end

    def post_params
      params.require(:post).permit(:page_id, :title, :content, :published,
                                    :published_at, :meta_description, :position)
    end
  end
end
