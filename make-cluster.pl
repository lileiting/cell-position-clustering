#!/usr/bin/env perl

use warnings;
use strict;
use FindBin;

sub usage {
    print <<"...";

    USAGE
        $FindBin::Script <cell-position> <cluster-from-mcl>

...
    exit;
}

sub main {
    usage unless @ARGV == 2;
    my ($cell_position_file, $cluster_from_mcl) = @ARGV;
    open my $fh1, $cluster_from_mcl or die $!;
    my %cluster;
    my $cls_idx = 1;
    while(<$fh1>){
        chomp;
        my @F = split /\t/;
        next if @F < 25;
        $cls_idx++;
        map{$cluster{$_}} @F;
    }
    close $fh1;

    open my $fh2, $cell_position_file or die $!;
    while(<$fh2>){
        s/[\r\n]//g;
        my ($x, $y) = split /\t/;
        my $key = $x . "_" . $y;
        print join("\t", $x, $y, ($cluster{$key} // 1)) . "\n";
    }
    close $fh2;

}

main unless caller;

__END__
