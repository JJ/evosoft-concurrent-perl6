#!/usr/bin/env perl6

use v6;

sub road-royale ( @χ ) {
    @χ.rotor(4).map( {so @_.all + so @_.none}).sum;
}

sub mutate ( @x is copy ) {
    @x[ (^@x.elems).pick ] ?^= True;
    @x;
}

sub xover( @x, @y ) {
    my @pairs = @x Z @y;
    my $xover1point = @x.keys.pick;
    my $xover2point = ($xover1point^..@x.elems).pick;
    my @crossed =  gather for @pairs.kv -> $index, @value {
        take ( ($xover1point <= $index <= $xover2point) ?? @value.reverse !!
            @value );
    }
    return [Z] @crossed;
}

sub MAIN( :$length = 64, :$population-size =  200 ) {

    my @population = ( Bool.pick() xx $length ) xx $population-size;
    say @population[0],@population[1];
    say xover( @population[0],@population[1]);
    loop {
        my $evaluated = @population.map( { @$_ => road-royale( @$_ ) } ).Mix;
        say "Evaluating ";
        last if any( $evaluated.values ) == $length/4;
        my @reproductive-pool = $evaluated.roll( $population-size );
        my @crossed = @reproductive-pool.pick( $population-size / 5 ).rotor(2).map( { xover( @$_[0], @$_[1] ) } );
        my @mutated = @reproductive-pool.pick( $population-size*3/5).map( {mutate(@$_)} );
        @population = ( @crossed.Slip, @mutated.Slip, @reproductive-pool.pick( $population-size / 5 ).Slip );
    }
    say @population;
}
