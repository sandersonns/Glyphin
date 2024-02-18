class GlyphsController < ApplicationController
  before_action :set_glyph, only: [:show, :edit, :update, :destroy]

  def index
    # Fetch glyphs owned by the current user
    @my_glyphs = current_user.glyphs

    # Fetch glyphs that are either public or are private but the current user has a redeemed token for
    # Explanation: This complex query fetches all glyphs that are not owned by the current user but are either public 
    # or have an associated redeemed token for the current user.
    @accessible_glyphs = Glyph.where.not(user: current_user).left_joins(:tokens).where(
      'glyph_privacy = :public OR (glyph_privacy = :private AND tokens.recipient_id = :user_id AND tokens.redeemed = :redeemed)', 
      public: false, private: true, user_id: current_user.id, redeemed: true
    ).distinct
  end

  def show
    # Already scoped to current_user by the before_action and set_glyph method
  end

  def new
    # Initialize a new glyph for the currently logged-in user
    @glyph = current_user.glyphs.build
  end

  def edit
    # Fetch the glyph to be edited that belongs to the currently logged-in user
    # Note: Already scoped to current_user by the before_action and set_glyph method
  end

  def create
    w3w_service = What3WordsService.new(ENV['WHAT3WORDS_API_KEY'])
    
    # Ensure latitude and longitude parameters are present
    if params[:lat].present? && params[:lng].present?
      # Convert coordinates to 3-word address
      @words = w3w_service.coordinates_to_words(params[:lat], params[:lng])
      
      # Error handling for the API call
      unless @words
        flash[:error] = "Failed to fetch the 3-word address. Please try again."
        render :new and return
      end
  
      # Find or create the what3words address record
      @w3w_address = What3words.find_or_create_by(address: @words)
  
    else
      flash[:error] = "Latitude and Longitude are required."
      render :new and return
    end
    
    # Build a new glyph with the submitted parameters, associating it with the correct What3words address
    @glyph = current_user.glyphs.build(glyph_params.merge(what3words_address: @w3w_address))
  
    # Try to save the glyph to the database
    if @glyph.save
      redirect_to @glyph, notice: 'Glyph was successfully created.'
    else
      render :new
    end
  end
  

  def update
    # Fetch the glyph to be updated that belongs to the currently logged-in user
    # Note: Already scoped to current_user by the before_action and set_glyph method

    # Try to update the glyph with the new parameters
    if @glyph.update(glyph_params)
      redirect_to @glyph, notice: 'Glyph was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Destroy associated tokens before destroying the glyph
    @glyph.tokens.destroy_all
    @glyph.destroy
    redirect_to glyphs_url, notice: 'Glyph was successfully destroyed.'
  end

  # Method to convert conventional address to What3Words
  def convert_to_w3w
    address = params[:address]
    result = What3wordsService.convert_to_coordinates(address) # Use our service to do the conversion
    render json: result
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_glyph
      @glyph = current_user.glyphs.find(params[:id])
    end

    # Strong parameters to prevent unwanted mass-assignment
    # Only allow specific fields to be updated via forms
    def glyph_params
      params.require(:glyph).permit(:title, :content, :glyph_privacy, :what3words_address_id)
    end
end
