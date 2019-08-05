#!/usr/bin/env perl6

use v6;

use Algorithm::Evolutionary::Simple;

sub road-royale ( @χ ) {
    @χ.rotor(4).map( {so @_.all + so @_.none}).sum;
}

sub MAIN( :$length = 64, :$population-size =  256 ) {

    my @population = ( Bool.pick() xx $length ) xx $population-size;

    do {
	my $evaluated = @population.map( { @$_ => road-royale( @$_ ) } ).Mix;
	last if any( $evaluated.values ) == $length/4;
	my @reproductive-pool = $evaluated.roll( $population-size );
	my @crossed = @reproductive-pool.pick( $population-size / 5 ).rotor(2).map( { crossover( @$^a, @$^b ) } );
	my @mutated = @reproductive-pool.pick( $population-size*3/5).map( {mutation(@$_)} );
	@population = ( @crossed.Slip, @mutated.Slip, @reproductive-pool.pick( $population-size / 5 ).Slip );
    }
}
