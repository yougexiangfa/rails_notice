# RailsNotice
`RailsNotice` 用于处理通告(Annunciation)，消息(Notification);

## 特性
* 只在用户请求数据时快速生成通知记录，避免僵尸用户产生的死数据；

## Usage
### Set the cable.yml
Should set adapter as redis in development
```yaml
development:
  adapter: redis
  url: redis://localhost:6379/1
```

### Import the js and css in the page which you want show notifications
```erb
<%= javascript_include_tag 'rails_notice/notice_channel', 'data-turbolinks-eval': 'false' %>
<%= stylesheet_link_tag 'rails_notice/cable' %>
```

### View: add link
```erb
<%= render 'notice_link' %>
```

### Model Setting
```ruby
# which model can receive notifications
class User < ApplicationRecord
  include RailsNotice::Receiver
end

```

### Controller Setting
```ruby
class ApplicationController < ActionController::Base
  include RailsNotice::Application
  
end
```

### Channel Setting
```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    prepend RailsNoticeConnection

  end
end
```

## 许可证
许可证采用 [MIT](https://opensource.org/licenses/MIT).
