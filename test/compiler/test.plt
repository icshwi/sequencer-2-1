use strict;
use Test::Simple tests => 8;

my $host_arch = $ENV{EPICS_HOST_ARCH};
my $snc = "../../../bin/$host_arch/snc";

my @success = qw(
  sncExOpt_DuplOpt
);

my @warning = qw(
  sncExOpt_UnrecOpt
  syncq_no_size
);

my @error = qw(
  misplacedExit
  syncq_not_assigned
  syncq_not_monitored
  syncq_size_out_of_range
);

if ($host_arch =~ /64/) {
  push(@error,"tooLong");
} else {
  push(@success,"tooLong");
}

sub make {
  my ($test) = @_;
  $_ = `make -s TESTPROD=$test 2>&1`;
  print("result=$?\n");
}

sub test_success {
  make(@_);
  ok($? != -1 and $? == 0 and not /error/ and not /warning/);
}

sub test_warning {
  make(@_);
  ok($? != -1 and $? == 0 and not /error/ and /warning/);
}

sub test_error {
  make(@_);
  ok($? != -1 and $? != 0 and /error/);
}

foreach my $t (@success) {
  test_success($t);
}

foreach my $t (@warning) {
  test_warning($t);
}

foreach my $t (@error) {
  test_error($t);
}
