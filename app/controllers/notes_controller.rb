class NotesController < ApplicationController
  before_action :set_student, only: [:new, :create]

  def new
    @note = @student.notes.build
  end
  
  # def create
  #   if @student.nil?
  #     flash[:alert] = "Student not found"
  #     render plain: "Student not found", status: :not_found
  #   else
  #     @note = @student.notes.build(note_params)
  
  #     if @note.content.blank?
  #       flash.now[:alert] = "Note content cannot be blank"
  #       render :new, status: :unprocessable_entity
  #     else
  #       note_content = @note.content
  #       note_content += "\nAdded by: #{current_user.email}" # Use email instead of username
  #       note_content += "\nAdded at: #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}"
  #       @note.content = note_content
        
  #       if @note.save
  #         redirect_to @student, notice: 'Note was successfully created.'
  #       else
  #         render :new
  #       end
  #     end
  #   end
  # end

  def create
    if @student.nil?
      flash[:alert] = "Student not found"
      render plain: "Student not found", status: :not_found
    else
      @note = @student.notes.build(note_params)
  
      if @note.content.blank?
        flash.now[:alert] = "Note content cannot be blank"
        render :new, status: :unprocessable_entity
      else
        @note.added_by = current_user.email # Set added_by
        @note.added_at = Time.current # Set added_at
  
        if @note.save
          redirect_to @student, notice: 'Note was successfully created.'
        else
          render :new
        end
      end
    end
  end
  
  # DELETE /students/:student_id/notes/:id
  def destroy
    @student = Student.find(params[:student_id])
    @note = @student.notes.find(params[:id])
  
    puts "Destroying note with ID: #{@note.id}" # Add this line for debugging
    @note.destroy
    redirect_to @student, notice: 'Note was successfully deleted.'
  end

  private

  def set_student
    @student = Student.find_by(id: params[:student_id])
  end

  def note_params
    params.require(:note).permit(:content, :student_id)
  end
end




