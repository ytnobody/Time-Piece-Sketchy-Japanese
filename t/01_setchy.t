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

subtest early_morning => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 05:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 未明 明け方 夜明け ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest morning => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 07:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 朝 朝方 モーニング ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest before_daytime => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 11:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 昼前 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest daytime => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 12:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 昼 正午 お昼時 ランチタイム お昼 昼間 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest afternoon => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 14:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 日中 午後 アフタヌーン ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest before_sunset => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 16:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 夕方前 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest before_sunset => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 17:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 夕方 夕暮れ 夕刻 暮れ方 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest trad_style => sub {
    my @zodiacs = ( qw( 子 子丑 丑 丑寅 寅 寅卯 卯 卯辰 辰 辰巳 巳 巳午 午 午未 未 未申 申 申酉 酉 酉戌 戌 戌亥 亥 亥子 ) );
    for my $hour ( 0 .. $#zodiacs ) {
        my $zodiac = $zodiacs[$hour] ;
        my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d '. sprintf( '%02d', $hour ) .':00:00'), '%Y-%m-%d %H:%M:%S' );
        my $pattern = $zodiac. 'の刻';
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest standard_style => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 10:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 一〇時 10時 １０時 十時 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest standard_style_p_m_ => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( $t->strftime('%Y-%m-%d 22:00:00'), '%Y-%m-%d %H:%M:%S' );
    for my $pattern ( qw( 午後一〇時 午後10時 午後１０時 午後十時 ) ) {
        my $t1 = $t->sketchy( $pattern );
        ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
    }
};

subtest mixed => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( '2012-02-29 03:00:00', '%Y-%m-%d %H:%M:%S' );
    my $pattern = '再来週の水曜日の丑寅の刻';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
};

subtest mixed2 => sub {
    my $expected = Time::Piece::Sketchy::Japanese->strptime( '2012-02-25 18:30:00', '%Y-%m-%d %H:%M:%S' );
    my $pattern = '来週土曜午後六時半';
    my $t1 = $t->sketchy( $pattern );
    ok $t1 == $expected, "$pattern is ". $t1->strftime('%Y-%m-%d %H:%M:%S');
};

done_testing;
