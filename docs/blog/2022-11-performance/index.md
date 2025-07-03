---
title: Trifle as an Application Performance Monitoring
date: '2022-11-06 21:42:39'
author: 'Jozef Vaclavik'
template: blog
---

# Trifle as Application Performance Monitoring

> NOTE: This is a re-post of a personal blog post from 2017. It talks about origins of `Trifle::Stats`.

![Beta version of Trifle build with Ember tracking one slow app.](./2022-11-performance/trifle-01.png)

Back in 2015 I decided to work on my own project in my free time. Believe me, I don’t have too much free time. As I became restless working only for clients, I decided to spend some time on my own project. I apologise in advance if I go too technical here.

## Why performance monitoring

Performance monitoring sucks. You heard me. Ok, I don’t want to be over dramatic, but it stinks. You have too many moving parts, and sometimes where one chart ends, you either don’t see in details, or you need more related information. It’s a pain.

## Just build your own

Then simple idea came to my head. Lets build my own Performance monitoring application. It can’t be that hard. There are plenty monitoring plugins available that one can get _inspired_. Sure it won’t be the best monitoring application, but I can control all the features and lead the direction.

## Rails in my way

Most of applications I’ve ever build are written in Ruby on Rails, I’ve been developing Rails applications since 2007 so I felt that my background is sufficient to master simple monitoring.

## Source of information

Rails 3 includes `ActiveSupport::Notifications` that allows you to subscribe to specific events. These events include controller action, template rendering, database queries, etc. All you need to do is make sure you calculate execution times properly together. Pretty simple.

I build a first version of a plugin that you include in your Rails application that collects, process and formats performance information from each request. Thats all the first version did. And it worked pretty well.

## Dashboard

Once you have source, you need to process, calculate and display the information. So first dashboard was made. Pure Rails application with some javascript charts. It was more of a proof of concept than functional product nor beta or even alpha version. It supported registrations, you could create there your own project, it helped you to set up everything and displayed first set of performance charts. There was no aggregation, application just displayed all the information as it was stored for each request. All data received from our plugin was processed on the fly by the API. This is fine for small applications that generate few thousands of requests per hour/day. Once you get to higher numbers, you will have too many requests to process and too much data display in charts. At this point I ran it on my own server where other apps were hosted. Yeah.

Pro tip: Never performance monitor same performance monitoring application. Each request generates request that generates request that generates request until end of the time. Logically. You can do it, but it requires some background processing, blacklisting, throttling and sampling.

## Websummit

At this point I felt pretty confident. Everything looked cool and I felt its time to show it to the world. I applied to Websummit and got accepted as an Alpha Startup. Formed a small team and made a decision to go. We just had to pay for plane tickets, hotel and 1200€ for conference tickets. Basically for free. Typical Websummit. Lol. Conference was cool, but thats another story. By the end of the conference every startup got $12000 for Google Cloud services that expired a year. Awesome! Totally worth it.

![Alpha version 1](./2022-11-performance/trifle-02a.png)
![Alpha version 2](./2022-11-performance/trifle-02b.png)

## Building statistics

Simple math tells you that if you have 500 requests per minute and you wanna display last 3 hours of data, you will get ~90000 objects to process. Thats just way too much. You could aggregate them on the fly, but there is easier solution. Most of the people don’t need per-second performance data. Per-minute is sufficient. The obvious solution is to put all values from desired time frame together in one statistic.

This way you group all requests from one minute into one object. Lets call it **PerformanceMinute**. Displaying last 3 hours would mean 180 objects. Significantly better. You can then go and create **PerformanceHour** and **PerformanceDay** to help you display more summary information per hour and day. Or you can aggregate on **PerformanceMinute**. It’s really up to you.

The price for this is that you have to process each request and update these performance statistics objects.

First you have to move away from live processing into background jobs. Just receive the data from source and move it to background queue as fast as you can (like <10ms fast).

Your background job processes the request and formats the performance data so we can store them together in chunk in the database.

Second problem you encounter is that while you are processing 1000 requests per second, you generate lots of write database operations which by default each locks the database row while writing. Thankfully we have MongoDB (don’t roll your eyes yet) that handles this beautifully. MongoDB allows you to upsert hash with increment function without save confirmation. Read that again.

> MongoDB allows you to upsert hash with increment function without save confirmation.

That operation is just blazingly fast. Just to give you a simple example, I ended up with something like this:

```ruby
PerformanceHour.collection.bulk_write([
  {
    update_many: {
      filter: {
        app_id: BSON::ObjectId.from_string(app_id),
        finished_at: finished_at.to_datetime.mongoize,
      },
      update: {
        ‘$inc’ => {
          time: 152.33,
          count: 15,
          ...
          browsers: {
            Safari: {
              11: 3
            },
            ...
          }
          errors: 1
      },
      upsert: true
    }
  }
])
```
And don’t tell me that this isn’t beautiful.

## Building Beta version

Rails is fine, but I wanted the application to feel more interactive. So we threw away our proof of concept and build proper API and Frontend client application for it. API was build again in Rails and for frontend we decided to use Ember.js. By that time I’ve build few applications in it and thought it will be good fit. We decided to use crossfilter.js for aggregation on frontend. That allowed me to make dashboard really interactive.

![Frontend build with Ember, Highcharts and Crossfilter](./2022-11-performance/trifle-03.png)

# What did I learn?

This was all good. But that was it. This was also the moment when real fun began and things went sideways.

## 1. Ruby is slow

Yeah, thats where we ended. Ruby can be fast, don’t get me wrong. Just understand that we are in performance monitoring market and when you start processing millions of transactions per day, every millisecond can cost you an another CPU core.

![Performance percentiles with sensitivity setting 1](./2022-11-performance/trifle-04a.png)
![Performance percnetiles with sensitivity setting 2](./2022-11-performance/trifle-04b.png)

## 2. Talk to clients often

I don’t want to get into too many details. Within the first month we got some testers. Bigger, smaller, all of them. Now that I look back, I don’t think we talked enough to them. One of them was running [_small_ open source project](https://libraries.io). I was excited, looked promising. At this moment any feedback was priceless. Unfortunately, he didn’t have time to give us some because he was busy. I didn’t feel like it was good idea to push more. After he replied that he will check in next week, but that was it. Now that I think of it, it would be better if I would push harder. We still got some feedback though. (I’m trying to stay positive about it)

![Performance histogram](./2022-11-performance/trifle-05.png)

## 3. Don’t sign new clients 10PM

It may sound like a good idea. You’re home out of your daily work routine. Your girlfriend is sleeping. You have the calmness of the night ahead of you. Why isn’t it now the great time to let new beta tester to use your app? Because things may go south when you least expect it!

Let me give you some more context. At this point we were monitoring 3 separate Rails applications. Our infrastructure consisted from 3xMongoDB in a cluster, 1x4CPU server for API and 1x4CPU server for Worker. Pretty overblown specs at that point.

Then he plugged his app 10PM. His application is scraping popular package registers like rubygems, npmjs and many others for changes/updates in projects. Lots of background jobs. And it was night of the scraping.

![Transactions/Jobs breakdown](./2022-11-performance/trifle-06.png)

## 4. Throw some more servers on a problem

As the queue was getting bigger and bigger (0.5 mil jobs at this point) I realized that it will not slow down and I have to help it. The easiest solution was to scale the workers up so we get more processing power. Here is the night when I got my first lesson from scaling. Its not just about spinning more servers and drinking beer. (12 am and 1.5 mil jobs in queue) I started to see different Database errors. Even that we had set up MongoDB cluster, we were still using just one node for all operations. First mistake. Put read operations to slaves. Done. (1am and 3 mil jobs in queue) Another issue was number of connections. You need to do the math from concurrent connections to your DB. Our number was lower then amount of workers times threads. Fixed. (2:30 am and 3.5 mil jobs in queue) Start sharding rather early. This was the next step in which I wanted to dive into, but luckily the queue started decreasing and it was 3am anyway. I went to bed for few hours and in the morning I checked the queue. 1 mil jobs and decreasing. By lunch time queue was empty and I could scale down the workers. What a night. Clearly, this was not sustainable solution. Throwing more processing power on the problem proved as a reliable solution, but optimisation seemed much better choice for the future.

![Exceptions tracking](./2022-11-performance/trifle-07.png)

## 5. It’s all fun until it’s not fun

At beginning everything felt new and exciting. That’s with all the projects. Eventually other work piled up and I had to focus away from Trifle to paid freelance work. I continued working on Trifle for next year or so over evenings and/or weekends. Unfortunately, I kept Trifle as a side project in pretty low key mode without trying to generate greater interest and always waiting for more features to be finished. I hit wall with some architectural decisions that I made in early stage and any further work required significant rewrite. It was hard to find time for that as the excitement was falling off. Trifle was running until we ran out of Google Cloud credit. Then I decided to shut it down and pivot.

# Time to move on?

Hopefully that’s not the end of the story. I believe I’ve build something useful, but got blocked by leading into wrong direction. I decided to move away from performance monitoring and started working on a rewrite. Much simpler architecture that is not focused on performance monitoring but rather on a providing answers from your statistical data. More about that next time or later. Whichever comes first.

> NOTE: The page you're visiting is a continuous effort messing around analytics for years.
