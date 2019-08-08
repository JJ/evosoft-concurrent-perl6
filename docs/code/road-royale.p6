#!/usr/bin/env perl6

use v6;


sub road-royale ( @χ ) {
    @χ.rotor(4).grep(  so (*.all == True|False) ).elems;
}

my @so-far = ();
for "111100001100001101011010".comb -> $c {
    @so-far.push:  $c.Int.Bool;
    say @so-far, " → ", road-royale( @so-far )
}