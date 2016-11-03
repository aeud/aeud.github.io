---
layout: post
title:  "Using alternative attribution models"
description: "The technique we've built at Sephora to use alternative attribution models"
date:   2016-11-02
categories: singapore sephora attribution model google analytics ga
author: ae
permalink: attribution-models
---
## Last Click attribution model

As businesses are publishing marketing medias through dozens of different channels, a possibility to attribute each earned dollar to one of them has quickly become a real necessity. Some tools appeared and helped to attributes these revenues to the different channels: Google Analytics is one of them.

If we fly back 10 years ago, the ability from the servers wasn't allowing these tools to calculate complex attribution models. Among all these models, a winner appeared: one which was good enough to represent something quite true, and not too complicated to implement, the last click attribution.

For the ones who don't know what the last click attribution model is, here is a concrete example. Let's imagine a customer sees an ad on Facebook, and lands on our website. This customer didn't purchase, but signed up. Few days later she received a commercial email, with a discount on her favorite brand: she clicked and landed again on a product page. She added it to her cart, but ... she's waiting few more hours, because she's meeting her sister few hours later, and maybe she could convince her to purchase one item too, so they could enjoy a free shipping treat, to be sure to not loose the product page, she's bookmarking the page. At 10PM she's going on the website again, with the bookmark, her sister definitely wants to purchase one too, and they checkout these 2 items.

In this case, even if our customer clicked on a Facebook ad, and an email we sent her, if we use the last click attribution model, the transaction will count for direct (bookmarked pages are counting as direct).

Today, using the last click attribution is not conceivable anymore: Facebook and Emails (in our example) should also be rewarded; they assisted the conversion!


## Hi complexity!

Google Analytics released few months ago a new feature called Multi Channel Funnel. Their goal is to memorize for each user (GA definition, cookie based), a list of channels they landed on the website by. With this "list of channels", they're able to calculate different attribution models to the different goals, and particularly to the transactions:

<img src="https://www.dropbox.com/s/6lg7s2hcvubva65/Screenshot%202016-11-03%2014.12.29.png?dl=1" alt="Models" style="max-width: 300px;">

The propose a list of built-in models, but of course, we can personalize them! The most famous are:

- Last click (always)
- First click (attributing the transaction to the channel which brought the customer on the website the very first time, Facebook ad in our previous example)
- 40% - 20% - 40%: this one is weird, but definitely  makes a lot of sense: if our customer purchased for $100, this model would attribute $40 to Facebook, $20 to Email and $40 to Direct.

That's great, except that they don't expose this data, as it implies giving "too much private information" about their users: funny when we know how much google know about us, isn't it?


## How to use these new models?

At Sephora, we decided we needed this data anyway! We need to attribute revenue and transactions with different models, and we're quite well convinced by the 40% - 20% - 40% method.

Unfortunately, a new method also means a new process, and in this case a lot of work to do the calculation: As I said, last click attribution model is easy to integrate, that's not the case for all these models!


### Material

First, let's focus on the material we need to be able to attribute our transactions to the channels, based on any model:


...

Any idea?

...

We need, for each order, a list of channels, sequenced, representing the channels which helped to land on the website before a transaction. For our example, that would be:

1. Facebook ad
2. Email
3. Direct

Guess what, this table is already in BigQuery, and called colors.orders_journey:

<img src="https://www.dropbox.com/s/zqvope484nnnbg8/Screenshot%202016-11-03%2014.25.16.png?dl=1" alt="BigQuery" style="max-width: 300px;">

- Each row represents a session from a customer prepending an order
- `account`, `orderId` are trivial, and represents the prepended order
- `channel` is the channel used by this session
- `sessionStartedAt` is a timestamp
- `visitNumber` represents n-th visit before the transaction
- `visitNumberDesc` is the reverse of the `visitNumber` field

Every time a customer makes a purchase, the sequence will be restarted for the following purchase.

For our example, this is how our tables looks like:

account | orderId | channel | sessionStartedAt | visitNumber | visitNumberDesc
--- | --- | --- | --- | --- | ---
default | 123 | Facebook Ad | 2016-09-01 21:35:43 | 1 | 3
default | 123 | Facebook Ad | 2016-09-04 14:12:21 | 2 | 2
default | 123 | Facebook Ad | 2016-09-04 22:15:08 | 3 | 1


### Let's build the model

We have no other choice to integrate our logic in the query everytime, so let's work with this example: we're creating a report to calculate for each day, how much (net revenue) is attributed to each channel, based on 20-40-20 attribution model:

```js

SELECT
  MONTH(TIMESTAMP(UTC_USEC_TO_MONTH(o.createdAt))) month,
  j.channel channel,
  ROUND(SUM(CASE
        WHEN j.visitNumber + j.visitNumberDesc = 2 THEN 1
        WHEN j.visitNumber = 1
      OR j.visitNumberDesc = 1 THEN 0.4
        ELSE 0.2 / (j.visitNumber + j.visitNumberDesc - 1)
      END * o.totals.validNetRevenue), 2) AS net
FROM
  [luxola.com:luxola-analytics:colors.orders_journey] j
LEFT JOIN
  dwh.orders o
ON
  o.account = j.account
  AND o.orderId = j.orderId
WHERE
    o.createdAt >= UTC_USEC_TO_YEAR(CURRENT_DATE())
GROUP BY
  1,
  2
LIMIT
  1000
```