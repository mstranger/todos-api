json.ignore_nil!

json.data do
  json.(project, :id)
  json.type :projects

  json.attributes do
    json.extract! project, :name, :created_at, :updated_at
  end

  json.relationships do
    json.user do
      json.data do
        json.type :users
        json.id project.user.id
      end
    end

    json.tasks do
      json.data project.tasks do |task|
        json.type :tasks
        json.id task.id
      end

      json.links do
        json.self api_v1_project_tasks_url(project)
      end
    end
  end

  json.links do
    json.self api_v1_project_url(project)
  end
end
