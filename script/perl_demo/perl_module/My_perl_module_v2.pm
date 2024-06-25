package My_perl_module_v2;

use parent qw(Exporter);
our @EXPORT = qw(Handle_argv);

sub print_and_exit {
    print @_, "\n";
    exit 1;
} # print_and_exit

sub read_argv {
    my ($aref, $hv) = @_;
    my ($opt);
    for my $arg ( @ARGV ) {
        if ( $arg =~ /^-/ ) {
            $opt = $arg;
            if ( exists $hv->{$opt} ){
                print_and_exit( "Repeated option: $arg" );
            }
            else {
                @{ $hv->{$opt} } = ();
            }
        }
        elsif ( defined $opt ){
            push @{ $hv->{$opt} }, $arg;
        }
        else {
            print_and_exit( "Un-support option: $arg" );
        }
    }
} # read_argv

sub check_argv_perl_type {
    my ($hr, $hv) = @_;
    for my $opt (keys %$hv) {
        if ( exists $hr->{$opt} ){
            if ( ${ $hr->{$opt} }{'perl_type'} eq 'scalar' ) {
                if ( @{ $hv->{$opt} } != 1 ) {
                    print_and_exit( "Error: only one parameter is expected to '$opt'" );
                }
            }
            elsif ( ${ $hr->{$opt} }{'perl_type'} eq 'array' ) {
                if ( @{ $hv->{$opt} } < 1 ) {
                    print_and_exit( "Error: one or more parameter is expected to '$opt'" );
                }
            }
            else {
                print_and_exit( "Error: unknown perl_type of '$opt'" );
            }
        }
        else {
            print_and_exit( "Un-support option: $opt" );
        }
    }
} # check_argv_perl_type

sub Handle_argv {
    my ($aref, $hr, $hv) = @_;
    read_argv($aref, $hv);
    check_argv_perl_type($hr, $hv);
} # handle_argv

1;