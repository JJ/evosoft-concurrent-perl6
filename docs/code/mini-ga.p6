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

sub barcode( @χ ) { @χ.map( {$_ ?? "■" !! "□"} ).join(""); }

sub MAIN( :$length = 40, :$population-size = 200 ) {
    my @population = ( Bool.pick() xx $length ) xx $population-size;
    my @best;
    loop {
        my $evaluated = @population.unique.map( { @$_ => road-royale( @$_ ) } ).Mix;
        my $best-so-far = $evaluated.values.max;
        say "Best so far $best-so-far";
        @best = $evaluated.grep( *.value == $best-so-far ); # Keep till end
        last if any( $evaluated.values ) == $length/4;

        my @reproductive-pool = $evaluated.roll( $population-size );
        @population= (@best.map: *.key).Array
            .append( @reproductive-pool.pick( $population-size / 5 ) )
            .append( @reproductive-pool.pick( $population-size / 5 ).rotor(2).map( { xover( @$_[0], @$_[1] ) } ) )
            .append: @reproductive-pool.pick( $population-size * 3/5 ).map( { mutate(@$_) } );

    }
    say barcode(@best[0].key);
}
