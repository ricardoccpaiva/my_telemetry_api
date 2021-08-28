## What is Telemetry
Somewhere during the lifetime of an application is inevitable that you'll face some performance issues. When that happens it's better that you have some kind of observability over it, otherwise it will significantly increase the time you'll take to find what's slowing it down. It may sound a bit cliché but it's 100% true that *we can't understand a system if we can't look inside it*.

This is the moment where **Telemetry** comes into place to make our lives easier. According to the dictionary, it's *the science or process of collecting information about objects that are far away and sending the information somewhere electronically*

## OpenTelemetry
There is an open-source initiative called OpenTelemetry that is the result of the merge between OpenCensus and OpenTracing and it's basically an observability framework for cloud-native software.
It consists in a collection of tools, APIs, and SDKs that you can use it to instrument, generate, collect, and export telemetry data (metrics, logs, and traces) for analysis in order to understand your software's performance and behavior.

The goal of this guide is to teach you how to instrument your Elixir application so that when you look into it it's no longer a black box. To help you with this task I've created a demo application that you can find out in this GitHub [repository](https://github.com/ricardoccpaiva/my_telemetry_api). It's a very simple Phoenix API that interacts with a Postgres database and an external HTTP API.

## Core dependencies and configuration 
Given that we will build an application that is going to be instrumented and export OpenTelemetry data, we need to add the [opentelemetry](https://hex.pm/packages/opentelemetry) dependency.

This is the implementation of the OpenTelemetry API and will start a Supervision tree, handling the necessary components for recording and exporting signals.

The Supervision Tree will look something like this: ![otel_sup](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/lzrmhpovlgteiwaxrcd1.png)

We also need to add this line to your application `start/2` function 👇
`OpenTelemetry.register_application_tracer(:my_telemetry_api)`

Next step is to configure our application and with this config block we are telling that our OpenTelemetry spans will be exported to stdout which in fact is not very usefull but don't worry, we'll cover this topic later on.

````Elixir
config :opentelemetry, :processors,
  otel_batch_processor: %{
    exporter: {:otel_exporter_stdout, []}
  }
````

## Instrument all the things
Next we need to start instrumenting our application and we'll cover 3 different areas.
- Phoenix HTTP requests
- Ecto queries
- External HTTP requests
- Custom instrumentation

We are going to use one library for each of these components and they are all very similar both in how you initialize them and how they work internally. They simply attach to Elixir Telemetry events and then act accordingly, i.e, creating OpenTelemetry spans.

## Phoenix HTTP requests
For this we'll use [opentelemetry_phoenix](https://github.com/opentelemetry-beam/opentelemetry_phoenix).

After installation, simply add the following line before your top-level supervisor starts.
`OpentelemetryPhoenix.setup()`


## Instrument Ecto queries
Just like the previous step, after installation of [opentelemetry_ecto](https://github.com/opentelemetry-beam/opentelemetry_ecto) simply add this line before your top-level supervisor starts. (make sure you replace `:blog` by your application name)

`OpentelemetryEcto.setup([:blog, :repo])`

## Instrument external HTTP requests

Last but not least, external API calls are also very common so we should also track them.
Again, install the required dependency, [opentelementry_tesla](https://github.com/ricardoccpaiva/opentelemetry_tesla/) and initialize it with the following line.
`OpentelemetryTesla.setup()`

## Custom instrumentation
In case there is the need to instrument specific zones of your code, that's also possible using [open_telemetry_decorator](https://github.com/marcdel/open_telemetry_decorator) library. It's simple as adding this dependency to your application and add two more lines of code.
- `use OpenTelemetryDecorator` to the module that you want to instrument
- `@decorate trace("span name")` to the function(s) that you want to trace

For more options please look at the oficial documentation.

## What's next?
At this point, if everything is correctly instaled and configured you should be able to see something on your terminal when you do some requests to your API. 

If you are having some struggle please take a look at this demo repository that I created: https://github.com/ricardoccpaiva/my_telemetry_api

Here it is an example.

````Elixir
*SPANS FOR DEBUG*
{span,104045074911526666048778887850624687080,8383464978060949812,undefined,
      9257592285879194880,<<"accounts.list_users">>,internal,
      -576460747138399000,-576460747128681000,[],[],[],undefined,1,false,
      {instrumentation_library,<<"my_telemetry_api">>,<<"0.1.0">>}}
````

You might be wondering.... *so... what's this data useful for?*

That's exactly the point, we need to transform this **data** into **information** so that we end with something like this:

![Screenshot 2021-08-28 at 23.31.33](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qsa5ha6kr6tro30dkckr.png)

This is a screenshot of Elastic APM, an application performance monitoring system built on the Elastic Stack. It allows this data to be displayed in a human readable fashion so that it turns into useful information for you.

In the next post, I'll show you step by step on how to send OpenTelemetry data to Elastic APM.

See you soon!


