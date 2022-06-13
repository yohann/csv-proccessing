class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  def import
    Contact.import(import_params[:contacts_file], import_params[:columns], current_user)

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: "File is being processed" }
    end
  end

  private
    
  def import_params
    params.permit(:contacts_file, columns: [:name, :email, :birth_date, :phone, :address, :credit_card])
  end
end
