class TokensController < ApplicationController
  # Before certain actions, fetch the specific token based on the token value provided.
  before_action :set_token, only: [:show, :redeem, :destroy, :validate_token]
  
  # List all issued tokens for a user
  def index
    @tokens = current_user.issued_tokens
  end

  # Issue a new token
  def create
    issuer = current_user
    # Allow searching for the recipient by their ID, email, or username.
    recipient = find_recipient if params[:recipient].present?

    if params[:recipient] && !recipient
      render json: { status: "error", message: "Recipient not found." } and return
    end

    @token = issuer.issued_tokens.build(recipient: recipient)
    @token.expires_at = params[:expires_at] if params[:expires_at].present?
    if @token.save
      render json: { status: "success", message: "Token successfully generated!" }
    else
      render json: { status: "error", message: @token.errors.full_messages.to_sentence }
    end
  end

  # Action to validate the token's validity without redeeming it.
  def validate_token
    # Check if the token has a recipient specified. If not, it's a general token.
    # If it has a recipient, then it should match the current user. 
    # In addition, the token should not be expired.
    if (@token.recipient.nil? || @token.recipient == current_user) && !@token.expired?
      # Token is valid and hasn't expired.
      render json: { status: "success", message: "Token is valid and ready for redemption!" }
      flash[:notice] = "The token is valid!"
    else
      # Either the token is not for the current user or it's already expired.
      render json: { status: "error", message: "Token is invalid or has already expired." }
      flash[:alert] = "Token is invalid or has expired."
    end
    # Redirect back to the index page after validation
    redirect_to tokens_path
  end

  # Redeem a token
  def redeem
    if (@token.recipient.nil? || @token.recipient == current_user) && !@token.expired?
      # ... handle successful redemption logic.
      # @token.destroy # Delete the token if needed
      render json: { status: "success", message: "Token successfully redeemed!" }
    else
      # Token is invalid or expired.
      render json: { status: "error", message: "Token is invalid or has already expired." }
    end
  end

  # Destroy a token
  def destroy
    @token.destroy
    render json: { status: "success", message: "Token successfully destroyed." }
  end
  
  private

  def find_recipient
    recipient_param = params[:recipient] # Assuming the client will send recipient's id, email or username in this param
    User.find_by(id: recipient_param) || 
    User.find_by(email: recipient_param.downcase) ||
    User.find_by(username: recipient_param.downcase)
  end

  def set_token
    @token = Token.find_by(token_value: params[:token_value])
    unless @token
      render json: { status: "error", message: "Token not found." }
    end
  end

  # Strong parameters
  def token_params
    params.require(:token).permit(:recipient_id, :expires_at)
  end
end
