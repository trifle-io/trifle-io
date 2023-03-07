---
title: Drivers
description: Learn how Trifle::Logs::Drivers manipulate files.
nav_order: 5
---

# Drivers

Driver is a class that interacts interacts with logs. You can write your own driver, or use build in `File` driver. Each driver needs to support two methods.

## dump(message=String, namespace: String)
- `message` - string representation of a content you want to store.
- `namespace` - string identifier.

`dump` method is used to persist content. It's as simple as that. The only identifier here is the `namespace` that can be used to separate one log from the others.

## search(namespace: String, pattern: String, file_loc: String, direction: Symbol)
- `namespace` - string identifier.
- `pattern` - regexp pattern for filtering. Defaults to `nil`.
- `file_loc` - indicate current point of search. Defaults to `nil`.
- `direction` - symbol representation of direction for search. Defaults to `nil`.

`search` method is used to search through the logs. Without `file_loc` or `direction`, it _should_ iterate over last page of logs. To navigate to another page, set `file_loc` to either `min_loc` or `max_loc` of your Result and set `direction` to either `:prev` or `:next`.
