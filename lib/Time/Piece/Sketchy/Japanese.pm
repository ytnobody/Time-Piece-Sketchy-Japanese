package Time::Piece::Sketchy::Japanese;
use strict;
use warnings;
use utf8;
use parent qw( Time::Piece );
use Lingua::JA::Numbers;

our $VERSION = '0.01';

our %WEEKDAY = (
    '日' => 0, '月' => 1, '火' => 2, '水' => 3, '木' => 4, '金' => 5, '土' => 6,
);

our @MAPPER = (
    qr/^(きょう|その日|本日|当日|今日|今週|今月|今年|ことし|今世紀)/ => sub { $_[0] },
    qr/(.+の)?(きのう|昨日|前日|前の日)/ => sub { $_[0] - 86400 },
    qr/(.+の)?(あす|あした|明日|翌日|次の日|あくる日|明くる日)/ => sub { $_[0] + 86400 },
    qr/^(あさって|明後日)/ => sub { $_[0] + ( 86400 * 2 ) },
    qr/^(やな|やの|やね|弥の|し|明|再)(あさって|明後日|々後日)/ => sub { $_[0] + ( 86400 * 3 ) },
    qr/^(先|昨|前の)週/ => sub { $_[0] - ( 86400 * 7 ) },
    qr/^(来|次|次の)週/ => sub { $_[0] + ( 86400 * 7 ) },
    qr/^再来週/ => sub { $_[0] + ( 86400 * 14 ) },
    qr/^(先|昨|前|前の)月/ => sub { $_[0] - ( 86400 * $_[0]->month_last_day ) },
    qr/^(来|次|次の)月/ => sub { $_[0] + ( 86400 * $_[0]->month_last_day ) },
    qr/^(去|昨|前|前の|ゆく|往く)年/ => sub { my $days = $_[0]->is_leap_year ? 366 : 365; $_[0] - ( 86400 * $days ) },
    qr/^(来|次の|くる|きたる|来る)年/ => sub { my $days = $_[0]->is_leap_year ? 366 : 365; $_[0] + ( 86400 * $days ) },
    qr/(.+の)?(月|火|水|木|金|土|日)曜日?/ => sub {
        my ( $self, undef, $wday ) = @_;
        my $gap = $self->day_of_week - $WEEKDAY{$wday};
        $self - ( 86400 * $gap );
    },
    qr/(.+の)?(.+)日(前|後)/ => sub {
        my $self = shift;
        my $mode = pop;
        my $days = ja2num( pop );
        $mode eq '前' ? $self - ( 86400 * $days ) : $self + ( 86400 * $days );
    },
    qr/(.+の)?(.+)週間?(前|後)/ => sub {
        my $self = shift;
        my $mode = pop;
        my $weeks = ja2num( pop );
        $mode eq '前' ? $self - ( 86400 * 7 * $weeks ) : $self + ( 86400 * 7 * $weeks );
    },
    qr/(.+の)?(.+)月(前|後)/ => sub {
        my $self = shift;
        my $mode = pop;
        my $months = pop;
        $months =~ s/(ヶ|箇|ヵ|か|個)//;
        $months = ja2num( $months );
        my $res = $self - 0;
        $mode eq '前' ? $res->add_mohths( -1 * $months ) : $res->add_months( $months );
    },
    qr/(.+の)?(.+)年(前|後)/ => sub {
        my $self = shift;
        my $mode = pop;
        my $years = ja2num( pop );
        my $res = $self - 0;
        $mode eq '前' ? $res->add_years( -1 * $years ) : $res->add_years( $years );
    },
);

sub sketchy {
    my ( $self, $str ) = @_;
    my @mapper = @MAPPER;
    while ( @mapper ) {
        my $regex = shift @mapper;
        my $code = shift @mapper;
        if ( my @args = $str =~ $regex ) {
            $self = $code->( $self, @args );
        }
    }
    return $self;
}

1;
__END__

=encoding utf8

=head1 NAME

Time::Piece::Sketchy::Japanese - 日本語であいまいな日時指定をするためのモジュール

=head1 SYNOPSIS

  use Time::Piece::Sketchy::Japanese;
  my $t = localtime;
  print $t->sketchy( '再来週の水曜日' )->strftime( '%Y-%m-%d %H:%M:%S' );

=head1 DESCRIPTION

Time::Piece::Sketchy::Japanese は Time::Piece のサブクラスです。

=head1 METHODS

=head2 sketchy

日本語での日時指定を渡すと、それにマッチした日時の Time::Piece オブジェクトを返します。

=head1 AUTHOR

satoshi azuma E<lt>ytnobody at gmail dot comE<gt>

=head1 SEE ALSO

Time::Piece

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
