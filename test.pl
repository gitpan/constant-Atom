package TestPackage;

use Test::More;
use strict;
BEGIN { plan tests => 13 };

use constant::Atom::Strict qw (red yellow blue);

my $color = red;

###This should produce an error.
eval {
	my $nono = "$color";
};
like($@, qr /Can't cast/);

###As should this.
eval {
	my $thing = $color + 1
};
like($@, qr /The.+operation isn\'t defined/);

###And this
#eval {
#	if($color == 5) {}
#};
#like($@, qr /operator isn\'t defined/);
ok($color == red);

###And this
eval {
	if($color =~ /SCALAR/) {}
};
like($@, qr /Can't cast/);



is($color, red);
isnt($color, blue);
isnt($color, "red");
isnt($color, "TestPackag::red");
is($color->name, 'red');
is($color->fullname, 'TestPackage::red');

use Data::Dumper;
like(Dumper(red), qr {bless.+do.+TestPackage::red.+constant::Atom::Strict});

###Check serialization.
use Storable qw (freeze thaw);
my $frozen = freeze($color);
my $thawed = thaw($frozen);
is($thawed, $color);

###Make sure non strict atoms work.
use constant::Atom qw (something);

my $okay = "".something;
like($okay, qr/constant::Atom=SCALAR/);
