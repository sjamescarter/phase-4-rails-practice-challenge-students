class InstructorsController < ApplicationController
  before_action :find_instructor, only: [:show, :update, :destroy]
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
  
  def index
    render json: Instructor.all
  end

  def show
    render json: @instructor
  end

  def create
    instructor = Instructor.create!(params.permit(:name))
    render json: instructor, status: :created
  end

  def update
    @instructor.update!(params.permit(:name))
    render json: @instructor, status: :accepted
  end

  def destroy
    @instructor.destroy
    head :no_content
  end

  private
  def find_instructor
    @instructor = Instructor.find(params[:id])
  end

  def not_found_response
    render json: { error: "Instructor not found" }, status: :not_found
  end

  def invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
