use strict;
use warnings;
use feature 'say';

my %variables;

sub show_help {
    print "\n***Perl Calculator***";
}

sub evaluate {
    my $expr = shift;
    

    if ($expr =~ /[^0-9\s\.\+\-\*\/\(\)a-zA-Z_=]/) {
        die "Hata: Geçersiz karakterler!\n";
    }
    

    $expr =~ s/([a-zA-Z_]\w*)/$variables{$1} || die "Hata: '$1' tanımsız değişken"/ge;
    

    while ($expr =~ /\(([^\(\)]+)\)/) {
        my $sub_expr = $1;
        my $result = evaluate($sub_expr);
        $expr =~ s/\([^\(\)]+\)/$result/;
    }
    

    while ($expr =~ /(-?\d+\.?\d*)\s*([\*\/])\s*(-?\d+\.?\d*)/) {
        my ($left, $op, $right) = ($1, $2, $3);
        my $result = $op eq '*' ? $left * $right : 
                    $right == 0 ? die "Hata: Sıfıra bölme!" : $left / $right;
        $expr =~ s/-?\d+\.?\d*\s*[\*\/]\s*-?\d+\.?\d*/$result/;
    }
    

    while ($expr =~ /(-?\d+\.?\d*)\s*([\+\-])\s*(-?\d+\.?\d*)/) {
        my ($left, $op, $right) = ($1, $2, $3);
        my $result = $op eq '+' ? $left + $right : $left - $right;
        $expr =~ s/-?\d+\.?\d*\s*[\+\-]\s*-?\d+\.?\d*/$result/;
    }
    
    return $expr;
}


show_help();

while (1) {
    print "\n> ";
    my $input = <STDIN>;
    chomp $input;
    
    last if $input =~ /^(exit|quit)$/i;
    
    if ($input =~ /^(help|\?)$/i) {
        show_help();
        next;
    }
    

    next if $input =~ /^\s*$/;
    

    if ($input =~ /^\s*([a-zA-Z_]\w*)\s*=\s*(.+)$/) {
        my ($var, $expr) = ($1, $2);
        eval {
            $variables{$var} = evaluate($expr);
            say "= $variables{$var}";
        };
        if ($@) {
            say "Hata: $@";
        }
        next;
    }
    

    eval {
        my $result = evaluate($input);
        say "= $result";
    };
    if ($@) {
        say "Hata: $@";
    }
}
