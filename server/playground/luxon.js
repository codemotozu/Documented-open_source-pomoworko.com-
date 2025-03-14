const { DateTime, Duration, Interval} = require('luxon');
//IMPORT DAYJS
const dayjs = require('dayjs');

console.log("--1---")

var end = DateTime.fromISO('2017-03-13');
var start = DateTime.fromISO('2017-04-13');
var diffInMonths = end.diff(start, 'seconds');

console.log(diffInMonths.toObject());

console.log("--Diffs---  ")
//* static date
var end_nextBillingTime =
DateTime.fromISO('2024-05-22T10:00:00.000+00:00');
//* static date

var start_paypalSubscriptionCancelledAt =
DateTime.fromISO('2024-05-22T09:59:00.000+00:00');
//* dynamic date

// var start_paypalSubscriptionCancelledAt =
// DateTime.now();

var diffInMonths = 
end_nextBillingTime.diff(start_paypalSubscriptionCancelledAt, 'seconds');

console.log(diffInMonths.toObject());



console.log(start_paypalSubscriptionCancelledAt)

var end = DateTime.fromISO('2024-05-22T10:00:00.000+00:00');
var start = DateTime.fromISO('2024-05-20T09:59:00.000+00:00');


console.log(end.diff(start, ['months', 'days', 'minutes', 'seconds']).toObject() )
console.log(end.diff(start, ['months', 'days', 'minutes', 'seconds']) )


console.log()

console.log("--comparing date times---")

d1= 1;
d2= 2;

d1 < d2



var d1 = DateTime.fromISO('2017-04-30');
var d2 = DateTime.fromISO('2017-04-01');


console.log(d2 < d1 )
console.log(d2.startOf('year') < d1.startOf('year') )
console.log(d2.startOf('month') < d1.startOf('month'))
console.log(d2.startOf('day') < d1.startOf('day') )

console.log("--DURATION---")

var dur = Duration.fromObject({ days: 3, hours: 6})

console.log(dur.toObject())

console.log(dur.as('minutes'))


console.log(dur.shiftTo('minutes').toObject())

console.log(DateTime.fromISO("2017-05-15").minus(dur).toISO() )



/***
 * 
 * console.logs
 * 
--1---
{ seconds: -2678400 }
--Diffs---
{ seconds: 60 }
DateTime { ts: 2024-05-22T04:59:00.000-05:00, zone: America/Bogota, locale: es-CO }
{ months: 0, days: 2, minutes: 1, seconds: 0 }

--comparing date times---
true
false
false
true
--DURATION---
{ days: 3, hours: 6 }
4680
{ minutes: 4680 }
2017-05-11T18:00:00.000-05:00
[nodemon] clean exit - waiting for changes before restart

 */