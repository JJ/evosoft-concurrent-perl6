#!/usr/bin/env perl6

use v6;

sub royal-road ( @χ ) {
    @χ.rotor(4).map( {so @_.all + so @_.none}).sum;
}

sub MAIN( :$length = 64, :$population-size =  256 ) {

    my @population = ( Bool.pick() xx $length ) xx $population-size;

    do {
	my @evaluated = @population.map( { @_ => royal-road( @_ ) } );
	say @evaluated;
    }
}
