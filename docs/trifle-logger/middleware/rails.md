---
title: Rails
description: Learn how to actually integrate Trifle::Logger into your Rails app.
nav_order: 3
---

# Rails

Instead of tracing every request ever made into your Rails app, there is better way to specify which requests are worth tracing. This implementation is using `around_action` controller callback.

## Configuration

You need to include `Trifle::Logger` mixin into your controller and specify which controller actions you would like to trace.

```ruby
# frozen_string_literal: true

class SessionsController < ApplicationController
  include Trifle::Logger::Middleware::RailsController
  with_trifle_logger only: %i[create]

  def create
    Trifle::Logger.trace('Lets steal some passwords!', head: true)
    # pls, this is not secure, dont do this!
    user = User.find_by(email: params[:email])

    if user && user.password == params[:password]
      Trifle::Logger.trace('Matching user') { user.id }
      Trifle::Logger.trace('Used password') { params[:password] }
      session[:user_id] = user.id
      redirect_to root_path
    else
      Trifle::Logger.ignore!
      redirect_to new_session_path, flash: {
        error: 'Uh oh! Thats a nono for the password.'
      }
    end
  end

  private

  def trace_meta
    [params[:email], params[:password]]
  end

  def trace_key
    "hack/sessions/#{params[:action]}"
  end
end
```
