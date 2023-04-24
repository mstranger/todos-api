json.ignore_nil!

json.data do
  json.(comment, :id)
  json.type :comments

  json.attributes do
    # json.extract! comment, :title, :project_id, :deadline, :priority, :completed
    json.(comment, :content)
  end

  json.relationships do
    json.task do
      json.data do
        json.type :tasks
        json.(task, :id)
      end

      json.links do
        json.related api_v1_project_task_url(project, task)
      end
    end

    json.user do
      json.data do
        json.type :users
        json.id project.user.id
      end
    end
  end

  json.links do
    json.self api_v1_project_task_comments_url(project, task)
  end
end
