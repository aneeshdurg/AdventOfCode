#!/usr/bin/perl
use warnings;
use strict;

open(FH, '<', 'input.txt') or die $!;

sub begins_with
{
    return substr($_[0], 0, length($_[1])) eq $_[1];
}

my %monkey_items = ();
my %monkey_ops = ();
my %monkey_tests = ();
my %monkey_true = ();
my %monkey_false = ();
my %monkey_inspects = ();

while (my $line = <FH>) {
  if (!begins_with($line, "Monkey")) {
    next;
  }
  my $monkey = substr($line, length("Monkey "), 1);

  my ($tmp, $starting_items) = split(": ", <FH>);
  my @items = map(int, split(", ", $starting_items));

  my @operation = split('= ', <FH>);
  my $op = $operation[1];
  $op =~ s/\n//g;

  my @test_raw = split("by ", <FH>);
  my $test = $test_raw[1];
  $test =~ s/\n//g;
  my @truth_stmt = split("monkey ", <FH>);
  my $true_branch = $truth_stmt[1];
  $true_branch =~ s/\n//g;
  my @false_stmt = split("monkey ", <FH>);
  my $false_branch = $false_stmt[1];
  $false_branch =~ s/\n//g;

  $monkey_items{$monkey} = [ @items ];
  $monkey_ops{$monkey} = $op;
  $monkey_tests{$monkey} = int($test);
  $monkey_true{$monkey} = $true_branch;
  $monkey_false{$monkey} = $false_branch;
  $monkey_inspects{$monkey} = 0;
}
close(FH);


# We only need to compute arithmetic in the modulo ring that's a super set of
# all the divisibility tests we need to do.
my $ring_param = 1;
for (my $i = 0; $i < keys %monkey_items; $i++) {
  my $key = "".$i;
  $ring_param *= $monkey_tests{$key};
}
my $reduction = 1;
my $rounds = 10000;

for (my $round = 0; $round < $rounds; $round++) {
  for (my $i = 0; $i < keys %monkey_items; $i++) {
    my $key = "".$i;
    my $test_val = $monkey_tests{$key};
    foreach my $item (@{$monkey_items{$key}}) {
      $monkey_inspects{$key}++;

      my $current_level = 0;
      my $level_op = $monkey_ops{$key};
      $level_op =~ s/old/$item/g;
      eval "\$current_level = $level_op;";

      # my $next_level = $current_level; # int($current_level / 3);
      my $next_level = $current_level % $ring_param; # int($current_level / 3);
      $next_level = int($next_level / $reduction); # int($current_level / 3);

      my $target = $monkey_false{$key};
      if (($next_level % $test_val) eq 0) {
        $target = $monkey_true{$key};
      }
      push(@{$monkey_items{$target}}, $next_level);
    }
    $monkey_items{$key} = [];
  }
}

my @inspect_counts = ();
for (my $i = 0; $i < keys %monkey_items; $i++) {
  my $key = "".$i;
  push(@inspect_counts, $monkey_inspects{$key});
  my $test_val = $monkey_tests{$key};
  print("  i $key $monkey_inspects{$key} [");
  foreach my $item (@{$monkey_items{$key}}) {
    print(" $item");
  }
  print(" ]\n");
}
@inspect_counts = sort {-1 * ($a <=> $b)} @inspect_counts;
my $monkey_business = $inspect_counts[0] * $inspect_counts[1];
print("$monkey_business\n");
