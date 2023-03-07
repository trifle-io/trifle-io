---
title: File
description: Learn how File driver access files.
nav_order: 1
---

# File Driver

Lets talk a `File` driver. Right now its the only driver available, but it doesn't need to be.

## Configuration

There are several options you can configure to get most out of your driver.

- `path` - file path to a folder your logs are located.
- `suffix` - timestamp `strptime` string used in file name. Defaults to `'%Y/%m/%d'`.
- `read_size` - number of lines per page. Defaults to `1000`.

`File` driver uses current time to generate log name. This ensures natural log rotation without need of checking file size on every write. You can customize how deep time-based rotation you need. If you store couple log messages every day, you may be good with storing all logs for a month in a single file as `suffix: '%Y/%m'`. If on the other side you have heavy write application, it's probably good idea to go deep down into per-hour as `suffix: '%Y/%m/%d/%h'`. You can use `/` or any other path compatible character. It will be used to create a folder & file. The last element is used as a file.

For example `Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m')` will create a todays log at `/var/log/trifle/2022/09.log`. And `Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m/%d_%h')` will create a todays log at `/var/log/trifle/2022/09/22_11.log`. Hope you get the point.

Depending on the length of your contnet, you may wanna tweak how many rows you search per page. If no search query is provided, searcher returns all log lines of the page. If your lines are too long, go for shorter page if you see slow performance. Otherwise push it higher and find your sweet spot.

## Dumping logs

`File` driver opens a file named with suffix based on a current timestamp.

```ruby
driver = Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m/%d')
driver.dump('This is a test message', namespace: 'test')
```

Thats it.

## Searching logs

`File` driver starts search from end of latest log file.

```ruby
driver = Trifle::Logs::Driver::File.new(path: '/var/logs/trifle', suffix: '%Y/%m/%d')
driver.search(namespace: 'test', pattern: nil)
```
