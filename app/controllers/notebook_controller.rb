class NotebookController < ApplicationController
  def index
    @notebook = Notebook.new
    effort1 = @notebook.new_effort
    effort1.name = "Marge"
    effort1.age = "13"
    effort1.publish
    effort2 = @notebook.new_effort(name: "Bruno")
    effort2.age = "15"
    effort2.publish
  end
end
