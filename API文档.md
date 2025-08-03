# Record 项目 API 文档

## 项目概述

Record 是一个基于 .NET 9.0 的项目管理和时间追踪应用，采用 Blazor Server + Web API 架构。该项目允许用户创建项目、管理任务，并记录每个任务的工作时间段。

## 技术栈

- **框架**: .NET 9.0
- **前端**: Blazor Server
- **数据库**: MySQL (通过 Pomelo.EntityFrameworkCore.MySql)
- **API文档**: Swagger/Swashbuckle
- **ORM**: Entity Framework Core 8.0

## 数据模型

### 1. Project（项目）
```csharp
{
    "Id": int,                    // 项目ID
    "Name": string,               // 项目名称（必填，最大200字符）
    "StartTime": DateTime,        // 开始时间
    "EstimatedEndTime": DateTime?, // 预计结束时间（可选）
    "Tasks": List<Task>           // 关联的任务列表
}
```

### 2. Task（任务）
```csharp
{
    "Id": int,                    // 任务ID
    "Name": string,               // 任务名称（必填，最大200字符）
    "Status": TaskStatus,         // 任务状态（InProgress=0, Completed=1）
    "ProjectId": int,             // 所属项目ID
    "Project": Project,           // 关联的项目
    "TaskPeriods": List<TaskPeriod> // 时间段列表
}
```

### 3. TaskPeriod（时间段）
```csharp
{
    "Id": int,                    // 时间段ID
    "StartTime": DateTime,        // 开始时间
    "EndTime": DateTime?,         // 结束时间（null表示进行中）
    "TaskId": int,                // 所属任务ID
    "Task": Task                  // 关联的任务
}
```

## RESTful API 接口

### 基础URL
- 开发环境: `http://localhost:5147/api`
- Swagger文档: `http://localhost:5147/swagger`

### 项目管理 API (/api/projects)

#### 1. 获取所有项目
- **URL**: `GET /api/projects`
- **描述**: 获取所有项目的列表
- **响应**: 
```json
[
    {
        "id": 1,
        "name": "示例项目",
        "startTime": "2025-01-01T00:00:00",
        "estimatedEndTime": "2025-12-31T23:59:59",
        "taskCount": 5
    }
]
```

#### 2. 根据ID获取项目
- **URL**: `GET /api/projects/{id}`
- **参数**: 
  - `id` (int): 项目ID
- **响应成功** (200):
```json
{
    "id": 1,
    "name": "示例项目",
    "startTime": "2025-01-01T00:00:00",
    "estimatedEndTime": "2025-12-31T23:59:59",
    "taskCount": 5
}
```
- **响应失败** (404):
```json
"项目 ID {id} 不存在"
```

#### 3. 创建新项目
- **URL**: `POST /api/projects`
- **请求体**:
```json
{
    "name": "新项目",                    // 必填，不超过100字符
    "startTime": "2025-01-01T00:00:00",  // 必填
    "estimatedEndTime": "2025-12-31T23:59:59" // 可选
}
```
- **响应** (201 Created):
```json
{
    "id": 2,
    "name": "新项目",
    "startTime": "2025-01-01T00:00:00",
    "estimatedEndTime": "2025-12-31T23:59:59",
    "taskCount": 0
}
```
- **响应头**: `Location: /api/projects/2`

#### 4. 更新项目
- **URL**: `PUT /api/projects/{id}`
- **参数**: 
  - `id` (int): 项目ID
- **请求体**:
```json
{
    "name": "更新后的项目名",             // 必填，不超过100字符
    "startTime": "2025-01-01T00:00:00",  // 必填
    "estimatedEndTime": "2025-12-31T23:59:59" // 可选
}
```
- **响应成功** (200):
```json
{
    "id": 1,
    "name": "更新后的项目名",
    "startTime": "2025-01-01T00:00:00",
    "estimatedEndTime": "2025-12-31T23:59:59",
    "taskCount": 5
}
```
- **响应失败** (404):
```json
"项目 ID {id} 不存在"
```

#### 5. 删除项目
- **URL**: `DELETE /api/projects/{id}`
- **参数**: 
  - `id` (int): 项目ID
- **响应成功** (204 No Content): 无响应体
- **响应失败** (404):
```json
"项目 ID {id} 不存在"
```

## 数据传输对象 (DTOs)

### ProjectDto
用于项目数据的传输：
```csharp
{
    "id": int,
    "name": string,               // 必填，最大100字符
    "startTime": DateTime,        // 必填
    "estimatedEndTime": DateTime?, // 可选
    "taskCount": int              // 任务数量
}
```

### CreateProjectDto
用于创建项目：
```csharp
{
    "name": string,               // 必填，最大100字符
    "startTime": DateTime,        // 必填
    "estimatedEndTime": DateTime?  // 可选
}
```

### UpdateProjectDto
用于更新项目：
```csharp
{
    "name": string,               // 必填，最大100字符
    "startTime": DateTime,        // 必填
    "estimatedEndTime": DateTime?  // 可选
}
```

### ApiResponse<T>
统一的API响应格式（虽然当前控制器未使用，但已定义）：
```csharp
{
    "success": bool,              // 是否成功
    "message": string,            // 响应消息
    "data": T,                    // 响应数据
    "errors": List<string>        // 错误信息列表
}
```

## Blazor 页面功能

虽然不是传统的 REST API，但项目还包含以下 Blazor 页面，提供了任务和时间段的管理功能：

### 1. 任务管理页面 (/tasks/{ProjectId})
- **功能**:
  - 查看项目下的所有任务
  - 创建新任务
  - 编辑任务（名称、状态）
  - 删除任务
  - 开始任务计时（创建新的时间段）
  - 结束任务计时（结束当前时间段）
  - 查看任务总用时

### 2. 时间段管理页面 (/taskperiods/{TaskId})
- **功能**:
  - 查看任务的所有时间段
  - 添加时间段记录
  - 编辑时间段（开始时间、结束时间）
  - 删除时间段
  - 标记任务为已完成/进行中
  - 查看总工作时间统计

## 服务层接口

### IProjectService
```csharp
interface IProjectService
{
    Task<List<Project>> GetAllProjectsAsync();
    Task<Project?> GetProjectByIdAsync(int id);
    Task<Project> CreateProjectAsync(Project project);
    Task<Project?> UpdateProjectAsync(int id, Project project);
    Task<bool> DeleteProjectAsync(int id);
}
```

## 使用示例

### 1. 创建项目
```bash
curl -X POST http://localhost:5147/api/projects \
  -H "Content-Type: application/json" \
  -d '{
    "name": "我的新项目",
    "startTime": "2025-01-01T09:00:00",
    "estimatedEndTime": "2025-06-30T18:00:00"
  }'
```

### 2. 获取所有项目
```bash
curl http://localhost:5147/api/projects
```

### 3. 更新项目
```bash
curl -X PUT http://localhost:5147/api/projects/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "更新后的项目名称",
    "startTime": "2025-01-01T09:00:00",
    "estimatedEndTime": "2025-12-31T18:00:00"
  }'
```

### 4. 删除项目
```bash
curl -X DELETE http://localhost:5147/api/projects/1
```

## 数据库配置

项目使用 MySQL 数据库，连接字符串配置在 `appsettings.json` 中：
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=服务器地址;Port=3306;Database=数据库名;Uid=用户名;Pwd=密码;CharSet=utf8mb4;"
  }
}
```

## 未来扩展建议

基于当前的项目结构，可以考虑添加以下 API：

1. **任务管理 API** (`/api/tasks`)
   - GET /api/projects/{projectId}/tasks - 获取项目的所有任务
   - GET /api/tasks/{id} - 获取任务详情
   - POST /api/tasks - 创建任务
   - PUT /api/tasks/{id} - 更新任务
   - DELETE /api/tasks/{id} - 删除任务
   - POST /api/tasks/{id}/start - 开始任务计时
   - POST /api/tasks/{id}/stop - 停止任务计时

2. **时间段管理 API** (`/api/taskperiods`)
   - GET /api/tasks/{taskId}/periods - 获取任务的所有时间段
   - GET /api/taskperiods/{id} - 获取时间段详情
   - POST /api/taskperiods - 创建时间段
   - PUT /api/taskperiods/{id} - 更新时间段
   - DELETE /api/taskperiods/{id} - 删除时间段

3. **统计 API** (`/api/statistics`)
   - GET /api/statistics/projects/{id}/summary - 获取项目统计
   - GET /api/statistics/tasks/{id}/time - 获取任务时间统计

## 注意事项

1. 所有日期时间使用 ISO 8601 格式
2. 项目名称和任务名称有长度限制
3. 删除项目可能会级联删除相关的任务和时间段（具体取决于数据库配置）
4. 当前仅实现了项目管理的 REST API，任务和时间段管理通过 Blazor 页面实现
