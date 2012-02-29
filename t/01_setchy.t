use strict;
use Test::More;
use Time::Piece::Sketchy::Japanese;
use utf8;

my $t = Time::Piece::Sketchy::Japanese->strptime( '2012-02-16 15:58:59', '%Y-%m-%d %H:%M:%S' );

isa_ok $t, 'Time::Piece::Sketchy::Japanese';

subtest yesterday => sub {
    my $expected = $t - 86400;
    for my $pattern ( qw( きのう 昨日 前日 前の日 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected->epoch, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest today => sub {
    my $expected = $t;
    for my $pattern ( qw( きょう 本日 当日 今日 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest tomorrow => sub {
    my $expected = $t + 86400;
    for my $pattern ( qw( あした あす 明日 翌日 次の日 あくる日 明くる日 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest day_after_tomorrow => sub {
    my $expected = $t + ( 86400 * 2 );
    for my $pattern ( qw( あさって 明後日 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest two_days_after_tomorrow => sub {
    my $expected = $t + ( 86400 * 3 );
    for my $pattern ( qw( 
        しあさって 明明後日 明々後日 再明後日 やなあさって やのあさって やねあさって
        弥の明後日 弥のあさって 再々後日 やな明後日 やの明後日 やね明後日
    ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest last_week => sub {
    my $expected = $t - ( 86400 * 7 );
    for my $pattern ( qw( 先週 昨週 前の週 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest next_week => sub {
    my $expected = $t + ( 86400 * 7 );
    for my $pattern ( qw( 来週 次週 次の週 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest last_month => sub {
    my $expected = $t - ( 86400 * 29 );
    for my $pattern ( qw( 先月 昨月 前月 前の月 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest next_month => sub {
    my $expected = $t + ( 86400 * 29 );
    for my $pattern ( qw( 来月 次月 次の月 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest last_year => sub {
    my $expected = $t - ( 86400 * 366 );
    for my $pattern ( qw( 去年 昨年 前年 前の年 ゆく年 往く年 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest next_year => sub {
    my $expected = $t + ( 86400 * 366 );
    for my $pattern ( qw( 来年 次の年 来る年 くる年 きたる年 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest last_week_monday => sub {
    my $expected = $t - ( 86400 * 10 );
    my $pattern = '先週の月曜日';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected,  "$pattern is ". $t1->strftime('%Y-%m-%d(%A) %H:%M:%S');
};

subtest next_week_saturday => sub {
    my $expected = $t + ( 86400 * 9 );
    my $pattern = '来週の土曜日';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected,  "$pattern is ". $t1->strftime('%Y-%m-%d(%A) %H:%M:%S');
};

subtest four_days_ago => sub {
    my $expected = $t - ( 86400 * 4 );
    for my $pattern ( qw( 4日前 ４日前 四日前 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest twelve_days_ahead => sub {
    my $expected = $t + ( 86400 * 12 );
    for my $pattern ( qw( 12日後 １２日後 一二日後 十二日後 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest three_days_ago => sub {
    my $expected = $t - ( 86400 * 3 );
    my $pattern = '今週の金曜日の四日前';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d(%A) %H:%M:%S');
};

subtest two_days_ahead => sub {
    my $expected = $t + ( 86400 * 2 );
    my $pattern = '先週の土曜日の七日後';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d(%A) %H:%M:%S');
};

subtest four_days_ahead => sub {
    my $expected = $t + ( 86400 * 4 );
    my $pattern = '明々後日の次の日';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d(%A) %H:%M:%S');
};

subtest two_week_ago => sub {
    my $expected = $t - ( 86400 * 14 );
    for my $pattern ( qw( ２週間前 二週前 2週前 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest four_months_ahead => sub {
    my $expected = $t + ( 86400 * ( 29 + 31 + 30 + 31 ) );
    for my $pattern ( '4月後', '四ヶ月後' ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest three_years_ago => sub {
    my $expected = $t->add_years( -3 );
    for my $pattern ( '３年前', '三年前' ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest two_week_ahead => sub {
    my $expected = $t + ( 86400 * 14 );
    for my $pattern ( qw( 再来週 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

done_testing;
