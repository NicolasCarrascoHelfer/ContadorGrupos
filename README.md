# Counter

## About

This program lets you set a custom counter that can be configured to increase the values flowing a predefined logic.

## Getting started

### Prerequisites

* Ruby 3.2.4
* Rails 7.1.2
* PostgreSQL 16

### Instalation

After configuring the PostgreSQL credentials in config/database.yml, creating the database and migrating it, run the program by executing:

```
$ rails s
```

Search in your browser [http://localhost:3000](http://localhost:3000) to access the list of counters.

### Increasing a counter

```
NextGroupsService.call(@group,@time)
```

### Getting a Group value

```
@group.value
```

## Create a counter

The counter is a group of independent segments with a stablished value and behavior when the counter increase its value.

### Group

First, create an object of the "Group" class considering the attributes:

#### name (string)

Counter's name

### Segment

Then you have to create an object of the "Segment" class considering the attributes:

#### category (string)

There are two types of segments:

* alpha: Alphanumeric values
* date: Contains a date

#### format (string)

Date exclusive. Determines the date distribution using the strftime format.

#### value (string)

The value that the segment will display in the counter.

#### base_value (string)

The segment value will change to this value when the time determined by the reset attribute has passed.

#### behavior (string)

Determines what the segment does when the counter increases.

* system: (date exclusive) The segment displays system's date when the counter increases
* correlative: (alpha exclusive) An unit is added to the segment value when the counter increases
* constant: The segment value remains constant

#### reset (string)

Determines after how many time the segment will return to its base value.

* day
* month
* year
* never

#### position (int)

The position where the segment value is displayed in the counter, from left to right.

#### group_id

The id of the group to which the segment belongs.
