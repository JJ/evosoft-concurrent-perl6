#!/usr/bin/env perl6

use v6;

use Algorithm::Evolutionary::Simple;

sub road-royale ( @χ ) {
    @χ.rotor(4).map( {so @_.all + so @_.none}).sum;
}

sub mutate ( @x is copy ) {
    @x[ (^@x.elems).pick ] ?^= True;
    @x;
}

sub xover( @x, @y ) {
    my @pairs = @x Z @y;
    say @pairs;
    my $xover1point = @x.keys.pick;
    my $xover2point = ($xover1point^..@x.elems).pick;
    say "$xover1point, $xover2point";
    my @crossed =  gather for @pairs.kv -> $index, @value {
        say @value;
        say @value.reverse;
        take ( ($xover1point <= $index <= $xover2point) ?? ["zape","zipi"] !!
            @value );
    }
    say @crossed;
    return [RZ] @crossed;
}

sub MAIN( :$length = 8, :$population-size =  200 ) {

    my @population = ( Bool.pick() xx $length ) xx $population-size;
    say @population[0],@population[1];
    say xover( @population[0],@population[1]);
#    loop {
#        my $evaluated = @population.map( { @$_ => road-royale( @$_ ) } ).Mix;
#        say "Evaluating ";
#        last if any( $evaluated.values ) == $length/4;
#        my @reproductive-pool = $evaluated.roll( $population-size );
#        my @crossed = @reproductive-pool.pick( $population-size / 5 ).rotor(2).map( { crossover( @$_[0], @$_[1] ) } );
#        my @mutated = @reproductive-pool.pick( $population-size*3/5).map( {mutate(@$_)} );
#        @population = ( @crossed.Slip, @mutated.Slip, @reproductive-pool.pick( $population-size / 5 ).Slip );
#    }
#    say @population;
}
