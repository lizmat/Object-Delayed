[![Actions Status](https://github.com/lizmat/Object-Delayed/workflows/test/badge.svg)](https://github.com/lizmat/Object-Delayed/actions)

NAME
====

Object::Delayed - export subs for lazy object creation

SYNOPSIS
========

```raku
use Object::Delayed;  # imports "slack" and "catchup"

# execute when value needed
my $dbh = slack { DBIish.connect: ... }
my $sth = slack { $dbh.prepare: 'select foo from bar' }

# action if value was actually created
LEAVE .disconnect with $dbh;

# lazy default values for attributes in objects
class Foo {
    has $.bar = slack { say "delayed init"; "bar" }
}
my $foo = Foo.new;
say $foo.bar;  # delayed init; bar

# execute asynchronously, produce value when done
my $prime1000 = catchup { (^Inf).grep( *.is-prime ).skip(999).head }
# do other stuff while prime is calculated
say $prime1000;  # 7919
```

DESCRIPTION
===========

Provides a `slack` and a `catchup` subroutine that will perform actions when they are needed.

SUBROUTINES
===========

slack
-----

```raku
# execute when value needed
my $dbh = slack { DBIish.connect: ... }
my $sth = slack { $dbh.prepare: 'select foo from bar' }
```

There are times when constructing an object is expensive but you are not sure yet you are going to need it. In that case it can be handy to delay the creation of the object. But then your code may become much more complicated.

The `slack` subroutine allows you to transparently create an intermediate object that will perform the delayed creation of the original object when **any** method is called on it. This can also be used to serve as a lazy default value for a class attribute.

To make it easier to check whether the actual object has been created, you can check for definedness or truthinesss of the object without actually creating the object. This can e.g. be used when wanting to disconnect a database handle upon exiting a scope, but only if an actual connection has been made (to prevent it from making the connection only to be able to disconnect it), e.g. by using a `LEAVE` phaser:

```raku
LEAVE .disconnect with $dbh;
```

catchup
-------

```raku
# execute asynchronously, produce value when done
my $prime1000 = catchup { (^Inf).grep( *.is-prime ).skip(999).head }
# do other stuff while prime is calculated
say $prime1000;  # 7919
```

The `catchup` subroutine allows you to transparently run code **asynchronously** that creates a result value. If the value is used in **any** way and the asychronous code has not finished yet, then it will wait until it is ready so that it can return the result. If it was already ready, then it will just give the value immediately.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Object::Delayed . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2020, 2021, 2023 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

