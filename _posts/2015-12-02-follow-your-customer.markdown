---
layout: post
title:  "Google Analytics: How to follow your customer"
description: "Last click attriution is not enough? Which campaigns are assisting our ceonversions? Which ones are disguting your customers? This is a small Google Analytic - BigQuery - Python tutorial to understand a bit better you customers' behavior."
date:   2015-12-02
categories: ga analytics tracking gtm google
author: ae
permalink: follow-your-customer
---



You have probably already heard about Google Analytics, aka GA. If not, basicaly, GA is a tool, provided by the big G, helping the website owners to understand more about their clients / readers.

Let's begin with an image: when you're working in a physical shop, there many ways to understand your clients. You can stand and wait all the day, observing what your client are doing. You can also set up cameras in your shop, and analyse the videos. You can also ask your staff who is in direct contact with your customers.

It's easy to study your clients in a shop ... but what about into your eShop? The answer is a **Web Analytics tool**!

There are few players proposing this kind of tool:

- [Google Analytics][url-ga], probably the most popular
- Kiss Metrics
- and many others

All these tools have advantages, and drawbacks. We'll study them in a future article.

Today, let's set up your first Analytics tool: GA. To begin with, we'll set up another tool which is as amazing as GA: [Google Tag Manager][url-gtm]. GTM is, as we can read, a Tag Manager: it's a tool which will let you manage all the future vendors you would one day set up on your website, like some advertisement tools, popup tools, other web analytics tool, ... It will also be important if you want to [track more specificaly your clients][url-blank].

First of all, create an account on [GTM website][url-gtm-create]. It will take you less than one minute. While your account and first container created, you should see this view:

![First view of GTM new account](https://dl.dropboxusercontent.com/s/ikg5guvxh45qqs5/Screenshot%202015-06-08%2010.46.42.png)

Next thing you'll have to do will be to copy / paste the displayed script into your html file:

{% highlight html %}
<html>
    <head>
        <!-- Other metas -->
        <!-- Google Tag Manager -->
        <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-5WHRPL"
        height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','GTM-5WHRPL');</script>
        <!-- End Google Tag Manager -->
    </head>
    <body><!-- Body --></body>
</html>
{% endhighlight %}

Once this is done, you won't have to code anymore into your HTML file, everything will be done directly from GTM. Before that, create an account on [Google Analytics][url-ga], if it's not already done.

In GTM, create a new tag, and choose the product: **Google Analytics**. Because you just created you GA account, you select Universal Analytics, which is actualy the last version of GA. In tracking ID, copy paste the code you'll fine in Google Analytics plateform > Home: (the code looks like this: UA-xxxxxx-xx)

![GA console](https://dl.dropboxusercontent.com/s/g1ignwr6y0h4tte/Screenshot%202015-06-08%2011.09.43.png)

Fire your tag on **All Pages**, then **Create the tag**. Last thing, you just have to publish your container from GTM (top right corner). After that, you'll be able to count your first visitors on Google Analytics console (Real time).

Have fun.

[url-ga]: https://www.google.com/analytics/
[url-gtm]: http://tagmanager.google.com/
[url-gtm-create]: https://tagmanager.google.com/#/admin/accounts/create
[url-blank]: #
