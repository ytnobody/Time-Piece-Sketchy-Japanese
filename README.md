# NAME

Time::Piece::Sketchy::Japanese - 日本語であいまいな日時指定をするためのモジュール

# SYNOPSIS

    use Time::Piece::Sketchy::Japanese;
    my $t = localtime;
    print $t->sketchy( '再来週の水曜日の丑寅の刻' )->strftime( '%Y-%m-%d %H:%M:%S' );

# DESCRIPTION

Time::Piece::Sketchy::Japanese は Time::Piece のサブクラスです。

# METHODS

## sketchy

日本語での日時指定を渡すと、それにマッチした日時の Time::Piece オブジェクトを返します。

# AUTHOR

satoshi azuma <ytnobody at gmail dot com>

# SEE ALSO

Time::Piece

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
