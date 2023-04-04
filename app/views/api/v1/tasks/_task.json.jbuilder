json.ignore_nil!

json.data do
  json.(task, :id)
  json.type :tasks
  json.attributes do
    json.extract! task, :title, :deadline, :priority, :completed
  end
  json.links do
    json.self api_v1_task_url(task, format: :json)
  end
end
