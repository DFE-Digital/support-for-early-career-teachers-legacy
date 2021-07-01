# frozen_string_literal: true

class CoreInductionProgrammes::MentorMaterialPartsController < ApplicationController
  include Pundit

  after_action :verify_authorized
  before_action :authenticate_user!
  before_action :load_mentor_material_part

  def show; end

  def edit; end

  def update
    @mentor_material_part.assign_attributes(mentor_material_part_params)

    if params[:commit] == "Save changes"
      @mentor_material_part.save!
      flash[:success] = "Your changes have been saved"
      redirect_to mentor_material_part_path
    else
      render action: "edit"
    end
  end

  def show_split
    @split_mentor_material_part_form = SplitMentorMaterialPartForm.new(title: @mentor_material_part.title, content: @mentor_material_part.content)
  end

  def split
    @split_mentor_material_part_form = SplitMentorMaterialPartForm.new(mentor_material_split_params)
    if @split_mentor_material_part_form.valid? && params[:commit] == "Save changes"
      ActiveRecord::Base.transaction do
        @new_mentor_material_part = MentorMaterialPart.create!(
          title: @split_mentor_material_part_form.new_title,
          content: @split_mentor_material_part_form.new_content,
          mentor_material: @mentor_material_part.mentor_material,
          next_mentor_material_part: @mentor_material_part.next_mentor_material_part,
          previous_mentor_material_part: @mentor_material_part,
        )
        @mentor_material_part.update!(title: @split_mentor_material_part_form.title, content: @split_mentor_material_part_form.content)
      end
      redirect_to mentor_material_part_path(@mentor_material_part)
    else
      render action: "show_split"
    end
  rescue ActiveRecord::RecordInvalid
    render action: "show_split"
  end

  def show_delete; end

  def destroy
    mentor_material = @mentor_material_part.mentor_material
    @mentor_material_part.destroy!
    redirect_to mentor_material_path(mentor_material)
  end

private

  def load_mentor_material_part
    @mentor_material_part = load_mentor_material_part_from_params
    authorize @mentor_material_part
  end

  def mentor_material_part_params
    params.permit(:content, :title)
  end

  def mentor_material_split_params
    params.require(:split_mentor_material_part_form).permit(:title, :content, :new_title, :new_content)
  end
end
