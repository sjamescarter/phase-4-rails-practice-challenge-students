class StudentsController < ApplicationController
  before_action :find_student, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  def index
    render json: Student.all
  end

  def show
    render json: @student
  end

  def create
    student = Student.new(student_params)
    instructor = Instructor.find(params[:instructor_id])
    instructor.students << student
    student.save!
    render json: student, status: :created
  rescue
    render json: { error: "Please assign an instructor" }, status: :not_found
  end

  def update
    @student.update!(student_params)
    render json: @student, status: :accepted
  end

  def destroy
    @student.destroy
    head :no_content
  end

  private
  def find_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.permit(:name, :major, :age)
  end

  def not_found_response
    render json: { error: "Student not found" }, status: :not_found
  end

  def invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
