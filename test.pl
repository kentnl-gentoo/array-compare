# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..20\n"; }
END {print "not ok 1\n" unless $loaded;}
use Array::Compare;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $i = 2;

my $comp = Array::Compare->new;

my @A = qw/0 1 2 3 4 5 6 7 8/;
my @B = qw/0 1 2 3 4 5 X 7 8/;
my @C = @A;

my %skip1 = (6 => 1);
my %skip2 = (5 => 1);

# Compare two different arrays - should fail
print $comp->compare(\@A, \@B) ? 'not ' : '', "ok ", $i++, "\n";

# Compare two different arrays but ignore differing column - should succeed
$comp->Skip(\%skip1);
print $comp->compare(\@A, \@B) ? '' : 'not ', "ok ", $i++, "\n";

# compare two different arrays but ignore non-differing column - should fail
$comp->Skip(\%skip2);
print $comp->compare(\@A, \@B) ? 'not ' : '', "ok ", $i++, "\n";

# Change separator and compare two identical arrays - should succeed
$comp->Sep('|');
print $comp->compare(\@A, \@C) ? '' : 'not ', "ok ", $i++, "\n";

# These tests should generate fatal errors - hence the evals

# Compare a number with an array
eval { print $comp->compare(1, \@A) };
#print "$@" if $@;
print $@ ? '' : 'not ', "ok ", $i++, "\n";

# Compare an array with a number
eval { print $comp->compare(\@A, 1) };
#print "$@" if $@;
print $@ ? '' : 'not ', "ok ", $i++, "\n";

# Call compare with only one argument
eval { print $comp->compare(\@A) };
#print "$@" if $@;
print $@ ? '' : 'not ', "ok ", $i++, "\n";

# Switch to full comparison
$comp->DefFull(1);

# @A and @B differ in column 6
# Array context
my @diffs = $comp->compare(\@A, \@B);
print scalar @diffs == 1 && $diffs[0] == 6 ?
  '' : 'not ', "ok ", $i++, "\n";

# Scalar context
my $diffs =  $comp->compare(\@A, \@B);
print $diffs ? '' : 'not ', "ok ", $i++, "\n";

# @A and @B differ in column 6 (which we ignore)
$comp->Skip(\%skip1);
# Array context
@diffs = $comp->compare(\@A, \@B);
print scalar @diffs == 0 ? '' : 'not ', "ok ", $i++, "\n";

# Scalar context
$diffs = $comp->compare(\@A, \@B);
print $diffs == 0 ? '' : 'not ', "ok ", $i++, "\n";

# @A and @C are the same
# Array context
@diffs = $comp->compare(\@A, \@C);
print scalar @diffs == 0 ? '' : 'not ', "ok ", $i++, "\n";

# Scalar context
$diffs = $comp->compare(\@A, \@C);
print $diffs  ? 'not ' : '', "ok ", $i++, "\n";

# Test arrays of differing length
my @D = (0 .. 5);
my @E = (0 .. 10);

$comp->DefFull(0);
print $comp->compare(\@D, \@E) ?  'not ' : '', "ok ", $i++, "\n";

$comp->DefFull(1);
@diffs = $comp->compare(\@D, \@E);
print scalar @diffs == 5 ?  '' : 'not ', "ok ", $i++, "\n";

$diffs = $comp->compare(\@D, \@E);
print $diffs == 5 ?  '' : 'not ', "ok ", $i++, "\n";

# Test Perms
my @F = (1 .. 5);
my @G = qw(5 4 3 2 1);
my @H = qw(3 4 1 2 5);
my @I = qw(4 3 6 5 2);

print $comp->perm(\@F, \@G) ? '' : 'not ', "ok ", $i++, "\n";
print $comp->perm(\@F, \@H) ? '' : 'not ', "ok ", $i++, "\n";
print $comp->perm(\@F, \@I) ? 'not ' : '', "ok ", $i++, "\n";
