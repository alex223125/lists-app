# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_list, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[index]

  # GET /lists
  def index
    form = Forms::Lists::ListsSearchForm.new(current_user: current_user)
    form.submit

    render json: form.results
  end

  # GET /lists/1
  def show
    render json: @list
  end

  # POST /lists
  def create
    @list = current_user.lists.new(list_params)

    if @list.save
      render json: @list, status: :created, location: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lists/1
  def destroy
    @list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def list_params
    params.require(:list).permit(:name, :is_public)
  end
end
