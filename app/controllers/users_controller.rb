class UsersController < ApplicationController
  def index
  end

  def user_params
    params.require(:user).permit(
      :user_name, :email, :id,
      contact_attributes: [:id, :phone_number, :extension]
    )
  end
end
