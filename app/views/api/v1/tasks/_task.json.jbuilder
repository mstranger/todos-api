json.ignore_nil!

json.data do
  json.(task, :id)
  json.type :tasks

  json.attributes do
    json.extract! task, :title, :project_id, :deadline, :priority, :completed
  end

  json.relationships do
    json.project do
      json.data do
        json.type :projects
        json.id project.id
      end

      json.links do
        json.related api_v1_project_url(project)
      end
    end
  end

  json.links do
    json.self api_v1_project_task_url(project, task)
  end
end
