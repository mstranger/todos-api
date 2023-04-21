json.ignore_nil!

json.data do
  json.(task, :id)
  json.type :tasks
  json.attributes do
    json.extract! task, :title, :project_id, :deadline, :priority, :completed
  end
  json.links do
    json.self api_v1_project_task_url(project, task)
    json.project api_v1_project_url(project)
  end
end
