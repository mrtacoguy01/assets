
## Examples

```
HH:mm              14:09
h:mm a             2:09 PM
HH:mm:ss           14:09:03
HH:mm E            14:09 Tue
HH:mm EEEE         14:09 Tuesday
d/M/yyyy           7/4/2026
MMMM d, yyyy       April 7, 2026
E, MMM d           Tue, Apr 7
yyyy-MM-dd         2026-04-07  (ISO 8601)
HH:mm zzzz         14:09 Eastern Daylight Time
'week' w           week 17
'❤️' HH:mm         ❤️ 14:09
```

---

## Year

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| y      | 2026     | Full year, no padding        |
| yy     | 26       | 2-digit year                 |
| yyy    | 2026     | At least 3 digits            |
| yyyy   | 2026     | 4-digit year (most common)   |
| Y      | 2026     | Week-based year              |
| YY     | 26       | 2-digit week-based year      |
| YYYY   | 2026     | 4-digit week-based year      |

---

## Quarter

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| Q      | 2        | Quarter number               |
| QQ     | 02       | Quarter, zero-padded         |
| QQQ    | Q2       | Abbreviated                  |
| QQQQ   | 2nd quarter | Full name                 |

---

## Month

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| M      | 4        | Month number, no padding     |
| MM     | 04       | Month number, zero-padded    |
| MMM    | Apr      | Abbreviated month name       |
| MMMM   | April    | Full month name              |
| MMMMM  | A        | Narrow month name            |
| L      | 4        | Stand-alone month number     |
| LL     | 04       | Stand-alone, zero-padded     |
| LLL    | Apr      | Stand-alone abbreviated      |
| LLLL   | April    | Stand-alone full name        |
| LLLLL  | A        | Stand-alone narrow           |

---

## Week

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| w      | 17       | Week of year (1–53)          |
| ww     | 17       | Week of year, zero-padded    |
| W      | 3        | Week of month                |

---

## Day

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| d      | 7        | Day of month, no padding     |
| dd     | 07       | Day of month, zero-padded    |
| D      | 112      | Day of year (1–366)          |
| F      | 2        | Day of week in month (e.g. 2nd Monday) |
| g      | 2451334  | Modified Julian day          |

---

## Weekday

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| E      | Tue      | Abbreviated weekday          |
| EE     | Tue      | Abbreviated weekday          |
| EEE    | Tue      | Abbreviated weekday          |
| EEEE   | Tuesday  | Full weekday name            |
| EEEEE  | T        | Narrow weekday name          |
| EEEEEE | Tu       | Short weekday name           |
| e      | 3        | Local weekday number         |
| ee     | 03       | Local weekday, zero-padded   |
| eee    | Tue      | Abbreviated                  |
| eeee   | Tuesday  | Full                         |
| eeeee  | T        | Narrow                       |
| eeeeee | Tu       | Short                        |
| c      | 3        | Stand-alone weekday number   |
| cccc   | Tuesday  | Stand-alone full weekday     |
| ccccc  | T        | Stand-alone narrow           |

---

## Period (AM/PM)

| Token  | Example  | Notes                              |
|--------|----------|------------------------------------|
| a      | PM       | AM or PM                           |
| b      | noon     | AM, PM, noon, midnight             |
| B      | in the afternoon | Flexible day period          |

---

## Hour

| Token  | Example  | Notes                              |
|--------|----------|------------------------------------|
| h      | 2        | 12-hour clock, no padding (1–12)   |
| hh     | 02       | 12-hour clock, zero-padded         |
| H      | 14       | 24-hour clock, no padding (0–23)   |
| HH     | 14       | 24-hour clock, zero-padded         |
| k      | 24       | 24-hour clock, no padding (1–24)   |
| kk     | 24       | 24-hour clock, zero-padded         |
| K      | 2        | 12-hour clock, no padding (0–11)   |
| KK     | 02       | 12-hour clock, zero-padded         |
| j      | 2 PM     | Locale-preferred hour format (use this for user-facing time, respects user's 12/24h setting) |

---

## Minute

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| m      | 5        | Minute, no padding           |
| mm     | 05       | Minute, zero-padded          |

---

## Second

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| s      | 9        | Second, no padding           |
| ss     | 09       | Second, zero-padded          |
| S      | 3        | Fractional seconds (tenths)  |
| SS     | 34       | Fractional seconds (hundredths) |
| SSS    | 345      | Milliseconds                 |
| A      | 69453000 | Milliseconds in day          |

---

## Timezone

| Token  | Example                   | Notes                                                    |
|--------|---------------------------|----------------------------------------------------------|
| z      | EST                       | Short specific timezone (changes with DST: EST / EDT)    |
| zz     | EST                       | Same as z                                                |
| zzz    | EST                       | Same as z                                                |
| zzzz   | Eastern Standard Time     | Full specific timezone — DST-aware, so it will show "Eastern Daylight Time" in summer and "Eastern Standard Time" in winter |
| Z      | -0500                     | RFC 822 offset                                           |
| ZZ     | -0500                     | RFC 822 offset                                           |
| ZZZ    | -0500                     | RFC 822 offset                                           |
| ZZZZ   | GMT-05:00                 | Localized GMT offset                                     |
| ZZZZZ  | -05:00                    | ISO 8601 offset                                          |
| O      | GMT-5                     | Short localized GMT offset                               |
| OOOO   | GMT-05:00                 | Full localized GMT offset                                |
| v      | ET                        | Short generic timezone (no DST distinction)              |
| vvvv   | Eastern Time              | Full generic timezone (no DST distinction)               |
| V      | usnyc                     | Timezone ID (short)                                      |
| VV     | America/New_York          | Timezone ID (full IANA)                                  |
| VVV    | New York                  | Exemplar city                                            |
| VVVV   | New York Time             | Generic location format                                  |
| x      | -05                       | ISO 8601 offset (no Z for UTC)                           |
| xx     | -0500                     | ISO 8601 offset                                          |
| xxx    | -05:00                    | ISO 8601 offset with colon                               |
| X      | -05                       | ISO 8601 offset (Z for UTC)                              |
| XX     | -0500                     | ISO 8601 offset (Z for UTC)                              |
| XXX    | -05:00                    | ISO 8601 offset with colon (Z for UTC)                   |

---

## Era

| Token  | Example  | Notes                        |
|--------|----------|------------------------------|
| G      | AD       | Abbreviated era              |
| GG     | AD       | Abbreviated era              |
| GGG    | AD       | Abbreviated era              |
| GGGG   | Anno Domini | Full era name             |
| GGGGG  | A        | Narrow era                   |

---