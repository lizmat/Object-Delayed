use v6.c;
use Test;
use Object::Delayed;

plan 11;

my @seen;

class Foo {
    has $.zip is rw = slack { @seen.push("Foo"); my $ = "foo" }
}

my $object = Foo.new;
is +@seen, 0, 'no attribute access yet';

# need to use .item to actually make it check the result, rather than type
is $object.zip.item, "foo", "does the attribute give the right value";
is +@seen,               1, "did we access the code once";
is $object.zip.item, "foo", "does the attribute still give the right value";
is +@seen,               1, "did we not access the code again";

lives-ok { $object.zip = "bar" }, "can we assign a slacked rw attribute";
is $object.zip, "bar", "did the value get assigned";
is +@seen,               1, "did we not access the code again";

@seen = ();
$object = Foo.new(zip => "bar");
is +@seen, 0, 'no attribute access yet';
is $object.zip, "bar", "does the attribute give the right value";
is +@seen, 0, 'still no attribute access yet';

# vim: ft=perl6 expandtab sw=4
