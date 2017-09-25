#!/usr/bin/env perl

use warnings;
use strict;
use FindBin;
use Getopt::Long;
use List::Util qw(max);

sub usage {
    print <<"...";

    USAGE
        $FindBin::Script <cell-position.txt>

    OPTIONS
        <cell-position.txt> Two-column tab-delimited file (X, Y coordinates), 
                            without header  
        -distance NUM       Cell-cell distance, default: 20
        -size NUM           Minimum cluster size, default: 25
        -help

...
    exit;
}

sub main {
    my %opt;
    GetOptions(\%opt, "distance=f", "help");
    usage if $opt{help} or @ARGV == 0;
    my $distance_cutoff = $opt{distance} // 20;
    my $cluster_size_cutoff = $opt{size} // 25;

    my @positions;
    my $infile = shift @ARGV;
    my $prefix = $infile;
    $prefix =~ s/\.txt$//;
    my $distance_file = "$prefix.distance.txt";
    my $raw_cluster_file = "$prefix.raw_cluster.txt";
    my $cluster_file = "$prefix.cluster.txt";
    open my $distance_fh, "> $distance_file" or die $!;
    open my $raw_cluster_fh, "> $raw_cluster_file" or die $!;
    open my $cluster_fh, "> $cluster_file" or die $!;

    open my $in_fh, $infile or die $!;
    while(<$in_fh>){
        s/[\r\n]//g;
        my ($x, $y) = split /\t/;
        push @positions, [$x, $y];
    }
    close $in_fh;

    my %cluster;
    for(my $i = 0; $i < $#positions; $i++){
        for(my $j = $i + 1; $j <= $#positions; $j++){
            my ($x1, $y1) = @{$positions[$i]};
            my ($x2, $y2) = @{$positions[$j]};
    	    my $d = sqrt(abs($x1 - $x2) ** 2 + abs($y1 - $y2) ** 2);
            my $pos1 = $x1 . "_" . $y1;
            my $pos2 = $x2 . "_" . $y2;
            next if $d >= $distance_cutoff;
            print $distance_fh join("\t", $pos1, $pos2, $d) . "\n";
            if(exists $cluster{$pos1} and not exists $cluster{$pos2}){
                $cluster{$pos2} = $cluster{$pos1};
            }
            elsif(not exists $cluster{$pos1} and exists $cluster{$pos2}){
                $cluster{$pos1} = $cluster{$pos2};
            }
            elsif(not exists $cluster{$pos1} and not exists $cluster{pos2}){
                if(values %cluster == 0){
                    $cluster{$pos1} = 1;
                    $cluster{$pos2} = 1;
                }
                else{
                    my $max_cls = max(values %cluster);
                    $cluster{$pos1} = $max_cls + 1;
                    $cluster{$pos2} = $max_cls + 1;
                }
            }
        }
    }

    my %size;
    for (@positions){
        my($x, $y) = @$_;
        my $key = $x . "_" . $y;
        next if not exists $cluster{$key};
        push @{$size{$cluster{$key}}}, $key;
    }

    %cluster = ();
    my $cls_idx = 1;
    for my $key (sort {$#{$size{$b}} <=> $#{$size{$a}}} keys %size){
        my @positions = @{$size{$key}};
        print $raw_cluster_fh "Cluster $key (",scalar(@positions), " cells): " , join(",", @positions) . "\n";
        next if @positions < $cluster_size_cutoff;
        $cls_idx++;
        map {$cluster{$_} = $cls_idx} @positions;
    }

    for (@positions){
        my ($x, $y) = @$_;
        my $key = $x . "_" . $y;
        print $cluster_fh join ("\t", $x, $y, ($cluster{$key} // 1)) . "\n";   
    }

}

main unless caller;

__END__
