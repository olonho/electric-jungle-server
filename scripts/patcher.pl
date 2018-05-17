sub correct($$) {
    my ($f,$s) = @_;
    my $lang = ($f =~ /lang=en/) ? "en" : "ru";
    $s = "<a href=\"main.jsp\%3F$s";
    $s .= "%26lang=$lang" unless ($s =~ /lang/);
    return "$s\"";
}
sub process($) {
    my $f = shift;
    if (-d $f) {
        opendir(DIR, $f) || die "cannot opendir $f: $!";
        my @d = grep { !/^\./} readdir(DIR);
        closedir DIR;        
        foreach (@d) {
            process("$f/$_");
        }
    } else {
        open (F, $f) || die "cannot open $f: $!";
        my $f1 = "$f.new";
        open (F1, ">$f1") || die "cannot open $f1: $!";
        while (<F>) {
            s/<a href=\"main.jsp\?(.+?)\"/&correct($f,$1)/ge;
            print F1 $_;
        }
        close F;
        close F1;
        rename($f1, $f);
    }
}
my $f = shift;
process($f);

