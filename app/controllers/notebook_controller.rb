class NotebookController < ApplicationController
  def index
    @notebook = Notebook.new
  end
end
