#!/usr/bin/env perl6

use v6;

sub road-royale ( @χ ) {
    @χ.rotor(4).grep(  so (*.all == True|False) ).elems;
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
    return ([Z] @crossed).Slip;
}

sub MAIN( :$length = 40, :$population-size = 200 ) {
    my @population = ( Bool.pick() xx $length ) xx $population-size;
    my $best;
    loop {
        print "Evaluating ";
        my $evaluated = @population.unique.map( { @$_ => road-royale( @$_ ) } )
                .Mix;
        say $evaluated.values.max;
        if any( $evaluated.values ) == $length/4 {
            $best = $evaluated.grep( *.value == $length/4 );
            last;
        }
        my @reproductive-pool = $evaluated.roll( $population-size );
        my @crossed = @reproductive-pool.pick( $population-size / 5 ).rotor(2).map( { xover( @$_[0], @$_[1] ) } );
        my @mutated = @reproductive-pool.pick( $population-size*3/5).map( {mutate(@$_)} );
        @population = ( @crossed.Slip, @mutated.Slip, @reproductive-pool.pick( $population-size / 5 ).Slip );
        }
    say $best;
}
